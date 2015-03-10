class ResourcesController < ApplicationController
  before_action :authenticate_user!
  #require 'asset-manager'
  require 'resource'
   require 'db_cleaner'
  

  def index
      @resources = Resource.all
      I18n.locale = :es
  end

  def new

  end

  def create
    begin
      resource = Resource.create(name: params[:name], description: params[:description])
      unless resource.valid? 
          raise "error, missing name and/or description"  
      end
      resource.save
      flash[:notice] = "El Aula fue creada exitosamente"
    rescue => e
      flash[:error] = "El Aula no pudo ser creada"
    end
    redirect_to resources_path 
  end


  def show
      @resource = Resource.find(params[:id])
  end

  def edit
      @resource = Resource.find(params[:id])
  end

  def update
    begin
      @resource = Resource.find(params[:id])
      @resource.name = params[:name]
      @resource.description = params[:description]
    
      @resource.save
      flash[:notice] = "El Aula fue modificada exitosamente"
    rescue => e
      flash[:error] = "El Aula no pudo ser modificada"
    end
    redirect_to resources_path
  end

  def destroy
    begin
      @resource = Resource.find(params[:id])
      @resource.destroy
      flash[:notice] = "El Aula fue eliminada exitosamente"
    rescue => e
      flash[:error] = "El Aula no pudo ser borrada"
    end
    redirect_to resources_path
   end
 

end
