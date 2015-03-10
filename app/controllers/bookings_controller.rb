class BookingsController < ApplicationController
  require 'resource'
  require 'db_cleaner'
    
  def index
    begin
        session[:options] ||= {}
        session[:options]['date'] ||= Date.today
        if params[:goto]
            date = Date.civil(params[:goto][:"day(1i)"].to_i,params[:goto][:"day(2i)"].to_i,params[:goto][:"day(3i)"].to_i)
            session[:options]['date'] = date
        else
            if params[:date]
                date = Date.parse(params[:date])
                session[:options]['date'] = date
            end
        end     
    

        @resources = Resource.all.collect {|r| [r.name, r.id]}
        session[:options]['resource_id'] ||= @resources.first.last.to_s

    # check if selected resource was changed by user
        if params[:resource_id]
          if @resources.detect {|name,id| id.to_s==params[:resource_id]}
            session[:options]['resource_id'] = params[:resource_id]
          end
        end 

    # initialize allowed_status
        @allowed_status = ['all', 'pending', 'approved']
        session[:options]['status'] ||= @allowed_status.first
    # check if selected status was changed by user      
        if params[:status]
          if @allowed_status.include?(params[:status])
            status = params[:status]
            session[:options]['status'] = status
          end
        end



    # put variables sent to view in sync with session[:options]      
        @resource_id = session[:options]['resource_id']
        @status = session[:options]['status']
        @date = session[:options]['date'].is_a?(String) ?  Date.parse(session[:options]['date']) : session[:options]['date']

        @resource = Resource.find(session[:options]['resource_id'])
        @all_slots = @resource.all_slots(session[:options]['date'],session[:options]['status'])
        render 'index'
    
    rescue Faraday::ClientError => e
        logger.error e.class.to_s + " - " + e.message + ' -> The API is not available'
        render 'api_not_available'
    rescue => e
        logger.error e.class.to_s + " - " + e.message     
    end
  end

 
    
  def new 
    begin
      @resource = Resource.find(params[:resource_id])
      @booking = Booking.for_resource(params[:resource_id]).create(from: params[:start], to: params[:finish], user: params[:user_id] )
      UserMailer.booking_created(@booking, @resource).deliver
      flash[:notice] = "La Reserva fue guardada exitosamente"
    rescue => e
      flash[:error] = "Booking Failed to save"
    end
      redirect_to bookings_path
  end

  def create
  end

  def edit

  end

  def update
    begin
      @resource = Resource.find(params[:resource_id])
      #byebug
      @booking = Booking.for_resource(params[:resource_id]).find(params[:id])
      remind_date = DateTime.parse(@booking.from) - 2.hours
      @booking.save   
      UserMailer.booking_approved(@booking, @resource).deliver
      #byebug
      UserMailer.delay_until(remind_date, :retry => false).booking_reminder(@booking.id, @resource.id)
      flash[:notice] = "La Reserva fue aprobada"
    rescue Redis::CannotConnectError => e
      #byebug
        logger.error e.class.to_s + " - " + e.message 
    rescue => e
      flash[:error] = "La Reserva no pudo ser aprobada"
    end
      redirect_to bookings_path
  end

  def destroy
    begin
      @resource = Resource.find(params[:resource_id])
      @booking=Booking.for_resource(@resource.id).find(params[:id])
      status=@booking.status
      # byebug
      @booking.destroy
      if status == 'pending'
        UserMailer.booking_rejected(@booking, @resource).deliver
        flash[:notice] = "La Reserva fue rechazada exitosamente"
      else
        UserMailer.booking_cancelled(@booking, @resource).deliver
        flash[:notice] = "La Reserva fue cancelada exitosamente"
      end
    rescue => e
      if status == 'pending'
        flash[:error] = "La Reserva no pudo ser rechazada"
      else 
        flash[:error] = "La Reserva no pudo ser cancelada"
      end            
    end
      redirect_to bookings_path
  end

end