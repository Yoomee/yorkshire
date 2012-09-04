class Mobile::PhotosController < MobileController
  
  load_resource
  
  def index
    @photos = Photo.all
  end
  
  def show
    
  end
  
end