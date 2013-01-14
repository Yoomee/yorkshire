class HomeController < ApplicationController
  
  def index
    @page = Page.find_by_slug('mobile-app')
    render "pages/views/list"
  end

end