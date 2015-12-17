class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string  :uid
      t.integer :recipient_id
      t.integer :donor_id
      t.integer :fund_id
      t.integer :designated_to
      t.string  :currency, limit: 4
      t.integer :amount_in_cents
      t.integer :stripe_fee_in_cents
      t.integer :onedonation_fee_in_cents
      t.integer :aggregated_fee_in_cents
      t.integer :received_in_cents
      t.integer :amount_in_cents_usd
      t.integer :stripe_fee_in_cents_usd
      t.integer :onedonation_fee_in_cents_usd
      t.integer :aggregated_fee_in_cents_usd
      t.integer :received_in_cents_usd
      t.string  :stripe_customer_id
      t.string  :stripe_charge_id
      t.string  :stripe_source_id
      t.string  :stripe_destination
      t.string  :stripe_amount_refunded
      t.string  :stripe_application_fee_id
      t.jsonb   :stripe_balance_transaction, null: false, default: '{}'
      t.string  :stripe_captured
      t.string  :stripe_created
      t.string  :stripe_currency
      t.text    :stripe_description
      t.jsonb   :stripe_dispute, default: '{}'
      t.string  :stripe_failure_code
      t.string  :stripe_failure_message
      t.jsonb   :stripe_fraud_details, default: '{}'
      t.jsonb   :stripe_metadata, default: '{}'
      t.string  :stripe_paid
      t.string  :stripe_receipt_number
      t.string  :stripe_refunded
      t.jsonb   :stripe_refunds, default: '{}'
      t.jsonb   :stripe_source, null: false, default: '{}'
      t.string  :stripe_statement_descriptor
      t.string  :stripe_status
      t.text    :message
      t.boolean :anonymous
      t.string  :remote_ip
      t.timestamps
    end

    add_index :donations, :uid
    add_index :donations, :recipient_id
    add_index :donations, :donor_id
    add_index :donations, :fund_id
    add_index :donations, :designated_to
    add_index :donations, :currency
    add_index :donations, :amount_in_cents
    add_index :donations, :stripe_fee_in_cents
    add_index :donations, :onedonation_fee_in_cents
    add_index :donations, :aggregated_fee_in_cents
    add_index :donations, :received_in_cents
    add_index :donations, :amount_in_cents_usd
    add_index :donations, :stripe_fee_in_cents_usd
    add_index :donations, :onedonation_fee_in_cents_usd
    add_index :donations, :aggregated_fee_in_cents_usd
    add_index :donations, :received_in_cents_usd
    add_index :donations, :stripe_customer_id
    add_index :donations, :stripe_charge_id
    add_index :donations, :stripe_source_id
    add_index :donations, :stripe_destination
    add_index :donations, :stripe_amount_refunded
    add_index :donations, :stripe_application_fee_id
    add_index :donations, :stripe_balance_transaction, using: :gin
    add_index :donations, :stripe_captured
    add_index :donations, :stripe_created
    add_index :donations, :stripe_currency
    add_index :donations, :stripe_dispute, using: :gin
    add_index :donations, :stripe_failure_code
    add_index :donations, :stripe_fraud_details, using: :gin
    add_index :donations, :stripe_metadata, using: :gin
    add_index :donations, :stripe_paid
    add_index :donations, :stripe_receipt_number
    add_index :donations, :stripe_refunded
    add_index :donations, :stripe_refunds, using: :gin
    add_index :donations, :stripe_source, using: :gin
    add_index :donations, :stripe_statement_descriptor
    add_index :donations, :stripe_status
    add_index :donations, :anonymous
    add_index :donations, :remote_ip
  end
end
