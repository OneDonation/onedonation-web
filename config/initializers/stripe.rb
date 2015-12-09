Stripe.api_key = ENV['STRIPE_SECRET_KEY']

STRIPE_COUNTRIES = [
  "AT", # Austria
  "AU", # Australia
  "BE", # Belgium
  "CA", # Canada
  "CH", # Switzerland
  "DE", # Germany
  "DK", # Denmark
  "ES", # Spain
  "FI", # Finland
  "FR", # France
  "GB", # Great Britain
  "IE", # Ireland
  "IT", # Italy
  "JP", # Japan
  "LU", # Luxembourg
  "MX", # Mexico
  "NL", # Netherlands
  "NO", # Normway
  "SE", # Sweden
  "US"  # United States
]

StripeEvent.configure do |events|
  events.all StripeResponder::BillingEventLogger.new(Rails.logger)
  events.subscribe 'account.updated', StripeResponder::StripeAccount.new

  events.subscribe 'customer.created', StripeResponder::StripeCustomer.new
  events.subscribe 'customer.updated', StripeResponder::StripeCustomer.new
end
