class PagesController < ApplicationController
  include YmCms::PagesController
  skip_before_filter :authenticate, :only => :show
end