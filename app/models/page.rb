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
  
  def app_color
    read_attribute(:app_color) || "#3DA1A1"
  end
  
  def app_link_color
    if parent.nil? || parent.slug == 'mobile-app'
      app_color
    else
      parent.app_color
    end
  end
  
  def app_header_image_url
    Page::app_header_image_url(app_header || parent.app_header)
  end
  
end

Page::APP_COLORS = %w{#3DA1A1 #2B835D #6DAB56 #AA6836 #8F3E5E #8F57A0}