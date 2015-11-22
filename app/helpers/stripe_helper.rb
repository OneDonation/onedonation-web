module StripeHelper
  def stripe_country_options(request)
    request_country = HTTParty.get(URI.parse("http://api.hostip.info/country.php?ip=#{request.remote_ip.to_s}"))
    priority_country = request_country.in?(["XX"]) ? "US" : request_country
    {
      selected: priority_country,
      priority_countries: [priority_country],
      only: [
        "AT",
        "AU",
        "BE",
        "CA",
        "CH",
        "DE",
        "DK",
        "ES",
        "FI",
        "FR",
        "GB",
        "IE",
        "IT",
        "JP",
        "LU",
        "MX",
        "NL",
        "NO",
        "SE",
        "US"
      ]
    }
  end

  def base_stripe_url
    base_url = "https://dashboard.stripe.com/"
    if Rails.env.development?
      "#{base_url}test"
    else
      "https://dashboard.stripe.com"
    end
  end

  def stripe_customer_path(user)
    "#{base_stripe_url}/customers/#{user.stripe_customer_id}"
  end

  def stripe_account_path(user)
    "#{base_stripe_url}/applications/users/#{user.stripe_account_id}"
  end
end
