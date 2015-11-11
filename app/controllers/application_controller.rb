class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_model
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

  def current_account
    @current_account ||= current_user.current_account
  end

  def subdomain
    request.subdomain
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(
                                                 :first_name,
                                                 :last_name,
                                                 :email,
                                                 :password,
                                                 :password_confirmation,
                                                 accounts_attributes: [
                                                     :country,
                                                     :current
                                                 ]
                                               )
                                             }

  end
end
