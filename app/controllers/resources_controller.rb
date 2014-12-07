class ResourcesController < ApplicationController
  before_action :authenticate_user!
  require 'rest_client'
  #require 'asset-manager'
  
  API_BASE_URL = "http://orient-vega.codio.io:9292/" 
  

  def index
    resources = RestClient::Resource.new("#{API_BASE_URL}/resources").get 
    @resources = JSON.parse(resources, :symbolize_names => true)[:resources]
    I18n.locale = :es
  end

  def new

  end

  def create
    uri = "#{API_BASE_URL}/resources"
    payload = params#.to_json # converting the params to json
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.post payload , :content_type => 'text/plain'
      flash[:notice] = "Resource Saved successfully"
      redirect_to resources_path # take back to index page, which now list the newly created user also
    rescue Exception => e
     flash[:error] = "Resource Failed to save"
     render :new
    end
  end



  def show
    uri = "#{API_BASE_URL}/resources/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    resource = rest_resource.get
    @resource = JSON.parse(resource, :symbolize_names => true)[:resource]
  end

  def edit
    uri = "#{API_BASE_URL}/resources/#{params[:id]}" # specifying format as json so that 
                                                      #json data is returned 
    rest_resource = RestClient::Resource.new(uri)
    resource = rest_resource.get
    @resource = JSON.parse(resource, :symbolize_names => true)[:resource]
  end

  def update
    uri = "#{API_BASE_URL}/resources/#{params[:id]}"
    payload = params
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.put payload , :content_type => 'text/plain'
      flash[:notice] = "Resource Updated successfully"
    rescue Exception => e
      flash[:error] = "Resource Failed to Update"
    end
    redirect_to resources_path
  end

  def destroy
    uri = "#{API_BASE_URL}/resources/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
     rest_resource.delete
     flash[:notice] = "Resource Deleted successfully"
    rescue Exception => e
     flash[:error] = "Resource Failed to Delete"
    end
    redirect_to resources_path
   end
 

end
