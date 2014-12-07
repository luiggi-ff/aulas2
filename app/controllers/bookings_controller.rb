class BookingsController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://orient-vega.codio.io:9292/" # base url of the API
  

  def index
    @resource=params[:resource]
    bookings = RestClient::Resource.new("#{API_BASE_URL}/resources/#{@resource[:id]}/bookings?status=all").get
    bookings = JSON.parse(bookings, :symbolize_names => true)[:bookings] 
    availability = RestClient::Resource.new("#{API_BASE_URL}/resources/#{params[:resource_id]}/availabilities").get 
availability = JSON.parse(availability, :symbolize_names => true)[:availabilities] 
    
    bookings.each do |b|
      user = User.find_by_id(b[:user])
      b[:user_name] = user[:full_name]
    end

    #@resource = {id: params[:resource_id].to_i, name: params[:resource_name]}

    @all_slots=bookings.concat( availability ) 
    @all_slots.sort! { |a,b| a[:start] <=> b[:start]}

end

  def new 

  end

  def create
    resource= params[:resource]
    uri = "#{API_BASE_URL}/resources/#{resource[:id]}/bookings"
    payload = params#.to_json # converting the params to json
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.post payload , :content_type => 'text/plain'
      flash[:notice] = "Booking Saved successfully"
      UserMailer.booking_created(current_user, params).deliver
        redirect_to resource_bookings_path(:resource => resource)
    rescue Exception => e
     flash[:error] = "Booking Failed to save"
     render :new
    end
  end

  def edit

  end

  def update
    resource= params[:resource]
    uri = "#{API_BASE_URL}/resources/#{resource[:id]}/bookings/#{params[:id]}"
    payload = params
    p params
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.put payload , :content_type => 'text/plain'
      UserMailer.booking_approved(current_user).deliver
      flash[:notice] = "Booking Updated successfully"
    rescue Exception => e
      flash[:error] = "Booking Failed to Update"
    end
    redirect_to resource_bookings_path(:resource => resource)
  end

  def destroy
    resource= params[:resource]
    uri = "#{API_BASE_URL}/resources/#{resource[:id]}/bookings/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
     rest_resource.delete
     
     flash[:notice] = "Booking Deleted successfully"
     UserMailer.booking_rejected(current_user).deliver
    rescue Exception => e
     flash[:error] = "Booking Failed to Delete"
    end
    redirect_to resource_bookings_path(:resource => resource)
  end

end
