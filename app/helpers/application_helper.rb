module ApplicationHelper
  def page_for_header_image(page)
    if @page.slug == "mobile-app" && page.children.first.try(:header_image)
      page.children.first
    elsif page.header_image.nil? && @page.slug == "universities"
      page.parent
    else
      page
    end
  end
end
