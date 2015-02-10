class BookingsController < ApplicationController
  require 'asset-manager'
    
  API_BASE_URL = "http://orient-vega.codio.io:9292/" # base url of the API
  

  def index
    session[:options] ||= {}
    # set defaults
    session[:options]['resource_id'] ||= '0'
    session[:options]['user_id'] = current_user.id
      

      
    if params[:goto]
        date = Date.civil(params[:goto][:"day(1i)"].to_i,params[:goto][:"day(2i)"].to_i,params[:goto][:"day(3i)"].to_i)
        session[:options]['date'] = date
    else
        if params[:date]
            date = Date.parse(params[:date])
        else
            date = Date.today
        end
        session[:options]['date'] = date
    end 
    

      
    @resources = [['all',0]] + Resource.all.collect {|r| [r.name, r.id]}
    @users = [['all',0]] + User.all.collect {|u| [u.email, u.id]}
    
      
# check if selected resource was changed by user
    if params[:resource_id]
      if @resources.detect {|name,id| id.to_s==params[:resource_id]}
       # resource_id=params[:resource_id]
#      else 
 #       resource_id= '0'
  #    end
      session[:options]['resource_id'] = params[:resource_id]
    end
    end 
      
      
      
      
# check if selected user was changed by user      
    if params[:user_id]
      if  current_user.admin? && @users.detect {|name,id| id.to_s==params['user_id']}
          session[:options]['user_id'] = params[:user_id]
      #else
      #    user_id = current_user.id
      end
    #else 
    #  user_id = current_user.id
    end
    #session[:options]['user_id'] = user_id

#    if params[:user_id]
#      if  current_user.admin? && @users.detect {|name,id| id.to_s==params['user_id']}
#          user_id = params[:user_id]
#      end
#    end
#    user_id ||= current_user.id
#    session[:options]['user_id'] = user_id
      
      
      
# initialize allowed_status based in resource selected and user.admin?      
    @allowed_status = ['all', 'pending', 'approved']
    if session[:options]['resource_id']=='0' || session[:options]['user_id'] != current_user.id.to_s
        @allowed_status = ['pending', 'approved']
    end  

# check if selected status was changed by user      
    if params[:status]
       if @allowed_status.include?(params[:status])
           status = params[:status]
           session[:options]['status'] = status
       end
    else 
       status = @allowed_status.first
       session[:options]['status'] = status
    end

      
      
# put variables sent to view in sync with session[:options]      
    @user_id = session[:options]['user_id']
    @resource_id = session[:options]['resource_id']
    @status = session[:options]['status']
    @date = session[:options]['date']
      
    # byebug
    if  session[:options]['resource_id']=='0' || session[:options]['user_id'].to_s != current_user.id.to_s
        all_bookings = Resource.all.collect {|r| r.all_slots(session[:options]['date'],session[:options]['status'])}.reject { |c| c.empty? }
        @user_bookings = all_bookings.select {|b| b.owner.user_id.to_s == session[:options]['user_id'].to_s}
        render 'index_by_user'  
    else 
       
       @resource = Resource.find(session[:options]['resource_id'])
       @all_slots = @resource.all_slots(session[:options]['date'],session[:options]['status'])
       render 'index_list'
    end
  end

  def new 
      #render 'bookings/new' , layout: true
    @resource = Resource.find(params[:resource_id])
    @booking = Booking.for_resource(@resource.id).create
    @booking.from = params[:start]
    @booking.to = params[:finish]
    @booking.user = params[:user_id]
    
    begin
      if @booking.save
        flash[:notice] = "Booking Saved successfully"
          UserMailer.booking_created(@booking, @resource).deliver
          #redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
          redirect_to bookings_path
      else 
          flash[:error] = "Booking Failed to save"
          #redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
          redirect_to bookings_path
      end
    rescue Exception => e
     flash[:error] = "Booking Failed to save"
     #redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
     redirect_to bookings_path
    end
  end

  def create
    #@resource = Resource.find(params[:resource_id])
    #@booking = Booking.for_resource(@resource.id).create
    #@booking.from = params[:from]
    #@booking.to = params[:to]
    #@booking.user = params[:user]
    #
    #begin
    #  if @booking.save
    #    flash[:notice] = "Booking Saved successfully"
    #      UserMailer.booking_created(@booking, @resource).deliver
    #      redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
    #  else 
    #      flash[:error] = "Booking Failed to save"
    #      redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
    #  end
    #rescue Exception => e
    # flash[:error] = "Booking Failed to save"
    # render :new
    #end
  end

  def edit

  end

  def update
    @resource = Resource.find(params[:resource_id])
    @booking = Booking.for_resource(@resource.id).find(params[:id])
    remind_date = DateTime.parse(@booking.from) - 2.hours
    begin
      @booking.save
      UserMailer.booking_approved(@booking, @resource).deliver
      UserMailer.delay_until(remind_date, :retry => false).booking_reminder(@booking.id, @resource.id)
      flash[:notice] = "Booking Updated successfully"
    rescue Exception => e
      flash[:error] = "Booking Failed to Update"
    end
      #redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
      redirect_to bookings_path
  end

  def destroy
      @resource = Resource.find(params[:resource_id])
      @booking=Booking.for_resource(@resource.id).find(params[:id])
    begin
        status=@booking.status
        @booking.destroy
        if status == 'pending'
            flash[:notice] = "Booking Rejected successfully"
            UserMailer.booking_rejected(@booking, @resource).deliver
        else
            flash[:notice] = "Booking Cancelled successfully"
            UserMailer.booking_cancelled(@booking, @resource).deliver
        end
    rescue Exception => e
        if status == 'pending'
            flash[:error] = "Booking Failed to Reject"
        else 
            flash[:error] = "Booking Failed to Cancel"
        end            
    end
      #redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
      redirect_to bookings_path
  end

end