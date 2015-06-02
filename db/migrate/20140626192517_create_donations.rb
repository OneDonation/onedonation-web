class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string  :uid
      t.integer :user_id
      t.integer :donor_id
      t.integer :fund_id
      t.string :stripe_id
      t.boolean :livemode
      t.boolean :paid
      t.string :status
      t.string :amount
      t.string :currency
      t.boolean :refunded
      t.json :source
      t.boolean :captured
      t.string :balance_transaction
      t.string :failure_message
      t.string :failure_code
      t.integer :amount_refunded
      t.string :customer
      t.string :invoice
      t.text :description
      t.json :dispute
      t.json :metadata
      t.string :statement_descriptor
      t.json :fraud_details
      t.string :receipt_email
      t.string :receipt_number
      t.string :destination
      t.string :application_fee

      t.timestamps
    end

    add_index :donations, :uid
    add_index :donations, :user_id
    add_index :donations, :donor_id
    add_index :donations, :fund_id
    add_index :donations, :stripe_id
    add_index :donations, :customer
    add_index :donations, :paid
    add_index :donations, :status
    add_index :donations, :currency
    add_index :donations, :refunded
    add_index :donations, :invoice
    add_index :donations, :destination

  end
end
