class Page < ActiveRecord::Base
  
  include YmCms::Page
  
  image_accessor :header_image
  
  has_many :children, :class_name => "Page", :foreign_key => 'parent_id', :conditions => ["draft = ? AND (slug IS NULL OR slug != 'app-welcome')", false], :order => :position

  class << self
    
    def app_background_image_url(num)
      "/assets/background_#{num || 1}.jpg"
    end
    
    def app_header_image_url(num)
      "/assets/header_#{num || 46}.jpg"
    end

    def view_names
      %w{basic tiled list university}
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
    (header_image || parent.header_image).thumb("460x").url
  end
  
end

Page::APP_COLORS = %w{#3DA1A1 #2B835D #6DAB56 #AA6836 #8F3E5E #8F57A0}