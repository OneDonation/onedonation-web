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

  def redirect_back_or_default(options = {})
    redirect_to (request.referer.present? ? :back : user_dashboard_path), options
  end

  def retrieve_stripe_account
    begin
      @stripe_account = Stripe::Account.retrieve(current_user.stripe_account_id)
    rescue *[Stripe::APIConnectionError, Stripe::AuthenticationError, Stripe::APIError, Stripe::RateLimitError] => e
      # TODO Add stripe issue details to NewRelic
      Rails.logger.debug "Stripe during retrieval of account: #{current_user.stripe_account_id}"
      Rails.logger.debug e.inspect
      # Redirect and warn
      redirect_back_or_default(notice: "Looks like we're was an error retrieving info from our merchant partner. Please try again and contact support@onedonation.com if the issue persists.")
    end
  end
end
