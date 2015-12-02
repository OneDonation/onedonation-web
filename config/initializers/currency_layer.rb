require 'money/bank/currencylayer'
MoneyRails.configure do |config|

  bank = Money::Bank::Currencylayer.new
  bank.access_key = Rails.application.secrets.currencylayer_api_key
  config.default_bank = bank

end
