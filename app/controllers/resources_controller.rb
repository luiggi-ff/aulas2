class ResourcesController < ApplicationController
  before_action :authenticate_user!
  require 'asset-manager'
  
  API_BASE_URL = "http://orient-vega.codio.io:9292/" 
  

  def index
      @resources = Resource.all
      I18n.locale = :es
  end

  def new

  end

  def create
      resource = Resource.create
      resource.name = params[:name]
      resource.description = params[:description]
    begin
      unless resource.valid? 
          raise "error, missing name and/or description"  
      end
      resource.save
      flash[:notice] = "Resource Saved successfully"
      redirect_to resources_path 
    rescue Exception => e
      flash[:error] = "Resource Failed to save"
      render :new
    end
  end


  def show
      @resource = Resource.find(params[:id])
  end

  def edit
      @resource = Resource.find(params[:id])
  end

  def update
      resource = Resource.find(params[:id])
      resource.name = params[:name]
      resource.description = params[:description]
    begin
      resource.save
      flash[:notice] = "Resource Updated successfully"
    rescue Exception => e
      flash[:error] = "Resource Failed to Update"
    end
    redirect_to resources_path
  end

  def destroy
    resource = Resource.find(params[:id])

    begin
     @resource.destroy
     flash[:notice] = "Resource Deleted successfully"
    rescue Exception => e
     flash[:error] = "Resource Failed to Delete"
    end
    redirect_to resources_path
   end
 

end
