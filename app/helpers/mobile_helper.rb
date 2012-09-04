module MobileHelper

  def image_for_with_retina(object, geo_string, options = {})
    #geo_string.gsub!(/\d+/){|n| n.to_i * 2} if @retina
    image_for(object, geo_string, options)  
  end  
  
  def active_tab_bar
    return nil if @page.nil?
    @page.slug == 'app-welcome' ? 'home' : 'info'
  end
  
  def app_background_image_style
    if @page.try(:children).present?
      "background-image: url(#{@page.app_background_image_url}); background-size: 100%;"
    end
  end
  
  def app_header_image_style
    if @page.try(:children).blank?
      "background-image: url(#{@page.app_header_image_url}); background-size: cover;"
    end
  end
  
  def app_body_class
    return nil if @page.nil?
    if @page.children.present?
      "page-list"
    else
      "page-show"
    end
  end
  
  def app_link_offset(num)
    until num <= 5
      num = num -5
    end
    [1, 3, 2, 2, 3, 2][num]
  end
  
  def mobile_home_path
    if home_page = Page.find_by_slug('mobile-app')
      mobile_page_path(home_page.id)
    else
      "#"
    end
  end
  
  def mobile_info_path
    if info_page = Page.find_by_slug('about-yorkshire')
      mobile_page_path(info_page.id)
    else
      '#'
    end
  end
  
  private
  def mobile_slug_path(slug)
    if page = Page.find_by_slug(slug)
      mobile_page_path(page.id)
    else
      '#'
    end    
  end
  
end