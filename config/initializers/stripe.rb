Stripe.api_key = ENV['STRIPE_SECRET_KEY']


StripeEvent.configure do |events|
  events.all StripeResponder::BillingEventLogger.new(Rails.logger)
  events.subscribe 'account.updated', StripeResponder::StripeAccount.new

  events.subscribe 'customer.created', StripeResponder::StripeCustomer.new
  events.subscribe 'customer.updated', StripeResponder::StripeCustomer.new
  events.subscribe 'customer.subscription.created', StripeResponder::StripeSubscription.new
  events.subscribe 'customer.subscription.updated', StripeResponder::StripeSubscription.new
  events.subscribe 'customer.subscription.deleted', StripeResponder::StripeSubscription.new
end
