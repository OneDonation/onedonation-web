json.array!(@bank_accounts) do |bank_account|
  json.extract! bank_account, :id, :user_id, :nickname, :stripe_bank_account_id, :stripe_bank_account_last4, :stripe, :country, :currency, :default
  json.url bank_account_url(bank_account, format: :json)
end
