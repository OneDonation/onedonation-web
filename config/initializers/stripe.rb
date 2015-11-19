Stripe.api_key = ENV['STRIPE_SECRET_KEY']


StripeEvent.configure do |events|
  events.all StripeResponder::BillingEventLogger.new(Rails.logger)
  events.subscribe 'account.updated', StripeResponder::StripeAccount.new

  events.subscribe 'customer.created', StripeResponder::StripeCustomer.new
  events.subscribe 'customer.updated', StripeResponder::StripeCustomer.new
end
