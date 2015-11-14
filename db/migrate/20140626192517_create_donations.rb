class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string  :uid
      t.integer :recipient_id
      t.integer :donor_id
      t.integer :fund_id
      t.string  :charge_id
      t.string  :customer_id
      t.boolean :paid, default: false
      t.string  :status
      t.string  :amount
      t.string  :currency
      t.boolean :refunded, default: false
      t.integer :amount_refunded
      t.string  :source_id
      t.jsonb   :source, null: false, default: '{}'
      t.boolean :captured, default: false
      t.string  :failure_message
      t.string  :failure_code
      t.text    :description
      t.jsonb   :dispute, null: false, default: '{}'
      t.jsonb   :metadata, null: false, default: '{}'
      t.string  :statement_descriptor
      t.jsonb   :fraud_details, null: false, default: '{}'
      t.string  :receipt_email
      t.string  :receipt_number
      t.string  :destination
      t.string  :application_fee

      t.timestamps
    end

    add_index :donations, :uid
    add_index :donations, :recipient_id
    add_index :donations, :donor_id
    add_index :donations, :fund_id
    add_index :donations, :charge_id
    add_index :donations, :customer_id
    add_index :donations, :paid
    add_index :donations, :status
    add_index :donations, :currency
    add_index :donations, :refunded
    add_index :donations, :destination

  end
end
