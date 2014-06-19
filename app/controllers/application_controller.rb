class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_model
  layout :layout_by_subdomain
  helper_method :subdomain

  def index
  end

  protected

  def layout_by_subdomain
    if devise_controller?
	     subdomain == "admin" ? "devise_staff" : "devise"
    else
	     subdomain == "admin" ? "staff" : "application"
    end
  end

  def authenticate_model
    if subdomain == "admin"
      if current_staff
        redirect_to admin_dashboard_path
      elsif request.path == "/login"
      	puts "authenticate staff"
        authenticate_staff!
      end
    else
      authenticate_user!
    end
  end

  private

  def subdomain
  	request.subdomain
  end
end