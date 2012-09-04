class Page < ActiveRecord::Base
  
  include YmCms::Page

  class << self
    
    def app_background_image_url(num)
      "/assets/background_#{num || 1}.jpg"
    end
    
    def app_header_image_url(num)
      "/assets/header_#{num || 11}.jpg"
    end
    
  end
  
  def app_background_image_url
    Page::app_background_image_url(app_background)
  end
  
  def app_header_image_url
    Page::app_header_image_url(app_header)
  end
  
end