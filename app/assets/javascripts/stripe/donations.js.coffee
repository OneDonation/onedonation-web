jQuery ->
  donation.initializeForm()

donation =
  initializeForm: ->
    $('#donation-form').submit (e) ->
      e.preventDefault()
      console.log "main form loop"
      donation.processCard()

  processCard: ->
    console.log "processingCard"
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, donation.processStripeResponse)

  processStripeResponse: (status, response) ->
    console.log "processingStriepResponse"
    if status == 200
      console.log response
      console.log "add card hidden input"
      $('#donation-form').prepend('<input type="hidden" value="'+response.id+'" name="stripe_token" />')
      $('#donation-form')[0].submit()
    else
      console.log(response.error.message)
      console.log(response)
      $('#stripe_error').text(response.error.message)
      # TODO: disable form
