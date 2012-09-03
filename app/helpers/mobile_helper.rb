module MobileHelper

  def image_for_with_retina(object, geo_string, options = {})
    #geo_string.gsub!(/\d+/){|n| n.to_i * 2} if @retina
    image_for(object, geo_string, options)  
  end  
  
end