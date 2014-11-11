class BookingsController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://localhost:9292/" # base url of the API
  

  def index
    uri = "#{API_BASE_URL}/resources/#{params[:id]}/bookings?status=all" # specifying json format in the URl
    rest_resource = RestClient::Resource.new(uri) # It will create
    #new rest-client resource so that we can call different methods of it
    p params
    bookings = rest_resource.get # will get back you all the detail in json format, but it
    #will we wraped as string, so we will parse it in the next step.
    @bookings = JSON.parse(bookings, :symbolize_names => true)[:bookings] # we will convert the return
    @bookings.each do |b|
      url = b[:links].first[:uri]
      id = URI(url).path.split('/').last
      b[:id] = id
    end
  end

end
