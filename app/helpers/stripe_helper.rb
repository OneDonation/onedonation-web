module StripeHelper
  def stripe_country_options(request)
    {
      selected: priority_country,
      priority_countries: ["US"],
      only: STRIPE_COUNTRIES
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
