jQuery ->
  bankAccount.initializeForm()
  $(document).on 'change', '#bank_account_country', (e) ->
    bankAccount.setupCurrencyOptionSelect($(this).val())


bankAccount =
  initializeForm: ->
    # Setup county/currency defaults
    bankAccount.setupCurrencyOptionSelect("US")
    # Override submit method for stripe
    $('#new_bank_account').submit (e) ->
      console.log 'bank account form'
      e.preventDefault()
      bankAccount.processBankAccount()

  processBankAccount: ->
    console.log "processingBankAccount"
    account =
      country:              $('#bank_account_country').val(),
      currency:             $('#bank_account_currency').val(),
      routing_number:       $('#routing_number').val(),
      account_number:       $('#account_number').val(),
      default_for_currency: $('#default_stripe_bank_account').val()
    Stripe.bankAccount.createToken(account, bankAccount.processStripeResponse)

  processStripeResponse: (status, response) ->
    console.log "processing bank account response"
    if status == 200
      console.log response
      console.log "add bank-account hidden input"
      $('#new_bank_account').prepend('<input type="hidden" value="'+response.id+'" name="stripe_token" />')
      $('#new_bank_account')[0].submit()
    else
      console.log(response.error.message)
      console.log(response)
      $('#stripe_error').text(response.error.message)
      # TODO: disable form

  # Currency Select helpers
  setupCurrencyOptionSelect: (country) ->
    $('#bank_account_currency').empty()
    $('#bank_account_currency').append('<option value="">Select a currency...</>')
    currencies = bankAccount.currencyOptionsByCountry(country)
    i = 0
    len = currencies.length
    while i < len
      $('#bank_account_currency').append('<option value="'+currencies[i][0]+'">'+currencies[i][1]+' ('+currencies[i][0]+')</>')
      i++

  currencyOptionsByCountry: (country) ->
    switch country
      when "AU" # Australia
        [
          ["AUD", "Australian Dollar"]
        ]
      when "AT" # Austria
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "BE" # Belgium
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "CA" # Canada
        [
          ["CAD", "Canadian Dollar"]
          ["USD", "United States Dollar"]
        ]
      when "DK" # Denmark
        [
          ["DKK", "Danish Krone"],
          ["NOK", "Norwegian Krone"],
          ["SEK", "Swedish Krona"],
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "FI" # Finland
        [
          ["DKK", "Danish Krone"],
          ["NOK", "Norwegian Krone"],
          ["SEK", "Swedish Krona"],
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "FR" # France
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "DE" # Germany
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "IE" # Ireland
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "IT" # Italy
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "JP" # Japan
        [
          ["JPY", "Japanese Yen"]
        ]
      when "LU"
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "MX" # Mexico
        [
          ["MXN", "Mexican Peso"]
        ]
      when "NL" # Netherlands
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "NO" # Norway
        [
          ["DKK", "Danish Krone"],
          ["NOK", "Norwegian Krone"],
          ["SEK", "Swedish Krona"],
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "SG" # Singapore
        [
          ["SGD", "Singapore Dollar"]
        ]
      when "es" # Spain
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "SE" # Sweden
        [

          ["DKK", "Danish Krone"],
          ["NOK", "Norwegian Krone"],
          ["SEK", "Swedish Krona"],
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "CH" # Switzerland
        [
          ["CHF", "Swiss Franc"],
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "GB" # Great Britain
        [
          ["EUR", "Euro"],
          ["GBP", "British Pound"],
          ["USD", "United States Dollar"]
        ]
      when "US" #United States
        [
          ["USD", "United States Dollar"]
        ]









