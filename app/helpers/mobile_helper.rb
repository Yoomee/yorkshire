module MobileHelper

  def image_for_with_retina(object, geo_string, options = {})
    #geo_string.gsub!(/\d+/){|n| n.to_i * 2} if @retina
    image_for(object, geo_string, options)  
  end  
  
  def app_background_image_style
    if @page.try(:children).present?
      "background-image: url(#{@page.app_background_image_url}); background-size: 100%;"
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
  
end