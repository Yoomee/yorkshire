class ApplicationController < ActionController::Base
  
  include YmUsers::ApplicationController
  
  protect_from_forgery

  #before_filter :authenticate
  
  AUTH_USERS = { "yorkshire" => "uni123" }

  private
  def authenticate
    return true unless Rails.env.production?
    if authenticate_or_request_with_http_basic{|username| AUTH_USERS[username]}
      session[:authorised] = true
      return true
    end
    false
  end

end