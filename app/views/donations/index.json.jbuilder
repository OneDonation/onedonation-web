json.array!(@donations) do |donation|
  json.extract! donation, :id, :stripe_id, :stripe_customer_id, :stripe_invoice_id, :description, :caputed, :paid, :refunded, :amount, :currency, :stripe_card_id, :card_last_four, :card_brand, :card_exp_month, :card_exp_year, :stripe_failure_message, :stripe_failure_code, :statement_description
  json.url donation_url(donation, format: :json)
end
