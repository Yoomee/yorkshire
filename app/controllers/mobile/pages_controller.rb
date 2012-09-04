class Mobile::PagesController < MobileController
  
  def show
    @page = Page.find(params[:id])
    @page_title = (@page.parent || @page).title
  end
  
end