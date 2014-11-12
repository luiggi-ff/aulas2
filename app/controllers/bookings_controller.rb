class BookingsController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://localhost:9292/" # base url of the API
  

  def index
 #   p params
    uri = "#{API_BASE_URL}/resources/#{params[:resource_id]}/bookings?status=all" # specifying json format in the URl
    rest_resource = RestClient::Resource.new(uri) # It will create
    #new rest-client resource so that we can call different methods of it
    bookings = rest_resource.get # will get back you all the detail in json format, but it
    #will we wraped as string, so we will parse it in the next step.
    @bookings = JSON.parse(bookings, :symbolize_names => true)[:bookings] # we will convert the return
    @bookings.each do |b|
      url = b[:links].first[:uri]
      id = URI(url).path.split('/').last
      b[:id] = id
    end
  end

  def new 

  end

  def create
    uri = "#{API_BASE_URL}/resources/#{params[:resource_id]}/bookings"
    payload = params#.to_json # converting the params to json
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.post payload , :content_type => 'text/plain'
      flash[:notice] = "Booking Saved successfully"
      redirect_to resource_bookings_path(:resource_id => params[:resource_id]) # take back to index page, which now list the newly created user also
    rescue Exception => e
     flash[:error] = "Booking Failed to save"
     render :new
    end
  end

  def edit

  end

  def update
    uri = "#{API_BASE_URL}/resources/#{params[:resource_id]}/bookings/#{params[:id]}"
    payload = params
    p params
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.put payload , :content_type => 'text/plain'
      flash[:notice] = "Booking Updated successfully"
    rescue Exception => e
      flash[:error] = "Booking Failed to Update"
    end
    redirect_to resource_bookings_path(:resource_id => params[:resource_id])
  end

  def destroy
    uri = "#{API_BASE_URL}/resources/#{params[:resource_id]}/bookings/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
     rest_resource.delete
     flash[:notice] = "Resource Deleted successfully"
    rescue Exception => e
     flash[:error] = "Resource Failed to Delete"
    end
    redirect_to resource_bookings_path
  end

end
