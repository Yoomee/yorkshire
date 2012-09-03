class Mobile::PagesController < MobileController
  
  load_and_authorize_resource
  
  def index
    @pages = Page.root
  end
  
  def show
    @page_title = (@page.parent || @page).title
  end
  
end