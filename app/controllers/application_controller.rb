class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_model
  before_action :ensure_stripe_data
  # before_action :default_breadcrumb
  layout :layout_by_subdomain
  helper_method :current_account,
                :subdomain

  def index
  end

  protected

  def layout_by_subdomain
    if devise_controller?
      if subdomain == "admin"
        "devise_staff"
      else
        case action_name
        when "edit"
          "application"
        else
          "devise"
        end
      end
    else
      subdomain == "admin" ? "staff" : "application"
    end
  end

  def authenticate_model
    if subdomain == "admin"
      authenticate_admin!
    else
      authenticate_user!
    end
  end

  def default_breadcrumb
    if user_signed_in?
      if current_user.accounts.any?
        add_breadcrumb current_account.business_name || nil, root_url
      else
        add_breadcrumb current_user.name("human"), root_url
      end
    end
  end

  private

  def ensure_stripe_data
    if user_signed_in?
      current_user.create_stripe_customer(request) unless current_user.stripe_customer_id
    end
  end

  def subdomain
    request.subdomain
  end
end
