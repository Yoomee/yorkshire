class PhotosController < ApplicationController
  
  load_and_authorize_resource

  def create
    if @photo.save
      flash_notice(@photo)
      redirect_to photos_path
    else
      render :action => "new"
    end
  end
  
  def destroy
    @photo.destroy
    flash_notice(@photo)
    redirect_to photos_path
  end
  
  def edit
    
  end
  
  def index
    @photos = Photo.all
  end
  
  def new
    
  end
  
  def update
    if @photo.update_attributes(params[:photo])
      flash_notice(@photo)
      redirect_to photos_path
    else
      render :action => "edit"
    end
  end
  
end