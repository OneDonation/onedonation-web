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
end
