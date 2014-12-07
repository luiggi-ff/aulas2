class BookingsController < ApplicationController
  require 'asset-manager'
    
  API_BASE_URL = "http://orient-vega.codio.io:9292/" # base url of the API
  

  def index
    @resource=Resource.find(params[:resource_id])
    bookings = Booking.for_resource(@resource.id).where(status: 'all')
    availability = Availability.for_resource(@resource.id).all
    @all_slots=bookings.concat( availability ) 
    @all_slots.sort! { |a,b| a[:start] <=> b[:start]}
  end

  def new 

  end

  def create
    @resource = Resource.find(params[:resource_id])
    @booking = Booking.for_resource(@resource.id).create
    @booking.from = params[:from]
    @booking.to = params[:to]
    @booking.user = params[:user]
    
    begin
      @booking.save
      flash[:notice] = "Booking Saved successfully"
        UserMailer.booking_created(@booking, @resource).deliver
        redirect_to resource_bookings_path
    rescue Exception => e
     flash[:error] = "Booking Failed to save"
     render :new
    end
  end

  def edit

  end

  def update
    @resource = Resource.find(params[:resource_id])
    @booking = Booking.for_resource(@resource.id).find(params[:id])
    begin
      @booking.save
      UserMailer.booking_approved(@booking, @resource).deliver
      flash[:notice] = "Booking Updated successfully"
    rescue Exception => e
      flash[:error] = "Booking Failed to Update"
    end
      redirect_to resource_bookings_path
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
      redirect_to resource_bookings_path
  end

end