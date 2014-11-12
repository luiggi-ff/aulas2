class AvailabilitiesController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://localhost:9292/" # base url of the API
  

  def index
 #   p params
    uri = "#{API_BASE_URL}/resources/#{params[:resource_id]}/availability" # specifying json format in the URl
    rest_resource = RestClient::Resource.new(uri) # It will create
    #new rest-client resource so that we can call different methods of it
    availability = rest_resource.get # will get back you all the detail in json format, but it
    #will we wraped as string, so we will parse it in the next step.
    @availability = JSON.parse(availability, :symbolize_names => true)[:availability] # we will convert the return
    @availability.each do |a|
      url = a[:links].first[:uri]
      id = URI(url).path.split('/').last
      a[:id] = id
    end
  end


end
