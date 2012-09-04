class Mobile::PagesController < MobileController
  
  def show
    @page = Page.find(params[:id])
    @page_title = (@page.parent || @page).title
    if @page.children.present?
      render :template => 'mobile/pages/page_list'
    else
      render :template => 'mobile/pages/page_show'
    end
  end
  
end