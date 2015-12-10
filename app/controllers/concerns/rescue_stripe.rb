# app/controllers/concerns/month_filtering_for_contests.rb
module RescueStripe
  extend ActiveSupport::Concern

  included do
    # Global Rescues
    # TODO: Add to NewRelic

    # APIConnection Error - generic error catch all
    rescue_from Stripe::APIConnectionError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      case exception.http_status
      when "400" # Bad request - The request was unacceptable, often due to missing a required parameter.
        redirect_back_or_default alert: t("stripe.errors.bad_request_html")
      when "401" # Unauthorized - No valid API key provided.
        redirect_back_or_default alert: t("stripe.errors.unauthorized_html")
      when "402" # Request Failed - The parameters were valid but the request failed.
        redirect_back_or_default alert: t("stripe.errors.request_failed_html")
      when "404" # Not Found - The requested resource doesn't exist."
        redirect_back_or_default alert: t("stripe.errors.not_found_html")
      when "429" # Too Many Requests - Too many requests hit the API too quickly."
        redirect_back_or_default alert: t("stripe.errors.too_many_requests_html")
      when "500", "502", "503", '504' # Server Errors - Something went wrong on Stripe's end. (These are rare.)
        redirect_back_or_default alert: t("stripe.errors.server_errors_html")
      end
    end

    # Authentication Errors - Bad API key (this should never happen)
    rescue_from Stripe::AuthenticationError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      redirect_back_or_default alert: t("stripe.errors.unauthorized_html")
    end

    # Invalid Request Errors - returned for invalid requests
    rescue_from Stripe::InvalidRequestError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      case exception.http_status
      when "400" # Bad request - The request was unacceptable, often due to missing a required parameter.
        redirect_back_or_default alert: t("stripe.errors.bad_request_html")
      when "404" # Not Found - The requested resource doesn't exist."
        redirect_back_or_default alert: t("stripe.errors.not_found_html")
      end
    end

    # Card Errors - when a card request fails
    rescue_from Stripe::CardError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      redirect_back_or_default alert: t("stripe.errors.request_failed_html")
    end

    # Rate limit errors - Too many requests hit the API too quickly.
    rescue_from Stripe::RateLimitError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      redirect_back_or_default alert: t("stripe.errors.too_many_requests_html")
    end

    # Stripe API Errors - Errors on Stripe's end. (These are rare.)
    rescue_from Stripe::APIError do |exception|
      Rails.logger.debug "Error '#{exception.http_status}' #{exception.message}"
      redirect_back_or_default alert: t("stripe.errors.server_errors_html")
    end
  end
end
