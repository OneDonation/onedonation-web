class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_model
  # before_action :check_account_complete?
  before_action :default_breadcrumb
  layout :layout_by_subdomain
  helper_method :subdomain, :current_account

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

  def check_account_complete?
    if user_signed_in? && !current_account.has_stripe_id?
      redirect_to setup_stripe_account_path
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

  # def after_sign_in_path_for(resource)
  #   if resource.setup_complete
  #      root_path
  #   else
  #     redirect_to account_setup_url
  #   end
  # end

  def current_account
    @current_account ||= current_user.current_account
  end

  def subdomain
  	request.subdomain
  end


  # def store_location
  #   # store last url - this is needed for post-login redirect to whatever the user last visited.
  #   return unless request.get?
  #   if (request.path != "/users/sign_in" &&
  #       request.path != "/users/sign_up" &&
  #       request.path != "/users/password/new" &&
  #       request.path != "/users/confirmation" &&
  #       request.path != "/users/sign_out" &&
  #       !request.xhr?) # don't store ajax calls
  #     session[:previous_url] = request.fullpath
  #   end
  # end

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
