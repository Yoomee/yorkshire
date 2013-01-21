class MapController < ApplicationController
  def show
    @universities = Page.find_by_slug("universities").children
  end
end