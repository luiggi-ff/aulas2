class BookingsController < ApplicationController
  require 'asset-manager'
    
  API_BASE_URL = "http://orient-vega.codio.io:9292/" # base url of the API
  

  def index
    
    
    #if params[:goto]
    #    @day = Date.civil(params[:goto][:"day(1i)"].to_i,params[:goto][:"day(2i)"].to_i,params[:goto][:"day(3i)"].to_i)
        #dmy = params[:goto][:"day(1i)"].to_i,params[:goto][:"day(2i)"].to_i,params[:goto][:"day(3i)"].to_i
        #if dmy[0]!=0 && dmy[1]!=0 && dmy[2]!=0
        #    @day = Date.civil(dmy)
        #end
    #end
      
    #@date = params[:date] ? Date.parse(params[:date]) : Date.today
    #if @date < Date.today
    #      @date = Date.today
    #end

    if params[:goto]
        @date = Date.civil(params[:goto][:"day(1i)"].to_i,params[:goto][:"day(2i)"].to_i,params[:goto][:"day(3i)"].to_i)
    else
        if params[:date]
            @date = Date.parse(params[:date])
        else
            @date = Date.today
        end
    end  
      
      
    @resources = [['all',0]] + Resource.all.collect {|r| [r.name, r.id]}
    @users = [['all',0]] + User.all.collect {|r| [r.email, r.id]}
      
    
    
    
    #if current_user.admin?
    #    @users = User.all.collect {|r| [r.email, r.id]}
    #else
    #    @users = [[current_user.email, current_user.id]]
    #end
        
    #if params[:new_resource_id]
    #    params[:resource_id] = params[:new_resource_id]
    #    @resource_id=params[:new_resource_id]
    #end
    @resource_id=params[:resource_id]
    @user_id=params[:user_id]
      
    #if params[:new_user_id]
    #    @user = Resource.find(params[:new_user_id])
    #else
    #    @user = current_user
    #end
      
      
    @allowed_status = ['all', 'pending', 'approved']
    
    if @resource_id=='0' || (current_user.admin? &&  @user_id.to_i != current_user.id)
        @allowed_status = ['pending', 'approved']
    end  
      
    #if current_user.admin?
    #    if @resource_id=='0' || @user_id.to_i != current_user.id
    #        @allowed_status = ['pending', 'approved']
    #    end
    #else 
    #    if @resource_id=='0'
    #        @allowed_status = ['pending', 'approved']
    #    end
    #end
     
    
      
    if  !params[:status].nil? 
       if @allowed_status.include?(params[:status])
           @status = params[:status]
       end
    else 
       @status = @allowed_status.first
    end

    
    session[:user_id] = @user_id
    session[:resource_id] = @resource_id
    session[:status] = @status
    session[:date] = @date
      
      
    #if params[:resource_id].nil? || 
    if  params[:resource_id]=='0'
        
        if current_user.admin? && !params[:user_id].nil? 
            @user_id = params[:user_id]
        else 
            @user_id = current_user.id
        end
        
        @user_bookings = Booking.get("/bookings", user: @user_id, status: @status)
        render 'index_by_user'  
    else 
       @resource = Resource.find(params[:resource_id])
       
       if @status!='all'
          @all_slots= @resource.bookings(@date,@status)
       else
          @all_slots = @resource.all_slots(@date,@status)
       end
        #byebug
        @all_slots.reject! {|s| s.start<Time.now}
        #@all_slots.sort! { |a,b| a[:start] <=> b[:start] }
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
          redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
      else 
          flash[:error] = "Booking Failed to save"
          redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
      end
    rescue Exception => e
     flash[:error] = "Booking Failed to save"
     redirect_to bookings_path(resource_id: params[:resource_id], user_id: params[:user_id],status: params[:status], date: params[:date])
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
      redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
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
      redirect_to bookings_path(resource_id: params[:resource_id], view: params[:view],status: params[:status])
  end

end