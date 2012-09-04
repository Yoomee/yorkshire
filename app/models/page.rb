class Page < ActiveRecord::Base
  
  include YmCms::Page
  
  def app_background_image
    'background_1.png'
  end
  
end