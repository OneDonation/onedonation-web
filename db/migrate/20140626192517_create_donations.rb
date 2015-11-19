class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string  :uid
      t.integer :recipient_id
      t.integer :donor_id
      t.integer :fund_id
      t.integer :designated_to
      t.string  :stripe_customer_id
      t.string  :stripe_charge_id
      t.string  :stripe_source_id
      t.string  :stripe_destination
      t.string  :stripe_amount
      t.string  :stripe_amount_refunded
      t.string  :stripe_application_fee
      t.string  :stripe_balance_transaction
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

      t.timestamps
    end

    add_index :donations, :uid
    add_index :donations, :recipient_id
    add_index :donations, :donor_id
    add_index :donations, :fund_id
    add_index :donations, :designated_to
    add_index :donations, :stripe_customer_id
    add_index :donations, :stripe_charge_id
    add_index :donations, :stripe_source_id
    add_index :donations, :stripe_destination
    add_index :donations, :stripe_amount
    add_index :donations, :stripe_amount_refunded
    add_index :donations, :stripe_application_fee
    add_index :donations, :stripe_balance_transaction
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

  end
end
