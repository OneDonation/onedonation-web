jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-public-key"]').attr('content'))

