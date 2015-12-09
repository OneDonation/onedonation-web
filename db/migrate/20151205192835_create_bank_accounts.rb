class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :uid
      t.integer :user_id
      t.string :nickname
      t.string :stripe_account_id
      t.string :stripe_bank_account_id
      t.string :stripe_bank_account_last4
      t.string :stripe_fingerprint
      t.string :country
      t.string :currency
      t.boolean :default_stripe_bank_account, default: false

      t.timestamps null: false
    end

    add_index :bank_accounts, :uid, unique: true
    add_index :bank_accounts, :user_id
    add_index :bank_accounts, :stripe_account_id
    add_index :bank_accounts, :stripe_bank_account_id
    add_index :bank_accounts, :stripe_bank_account_last4
    add_index :bank_accounts, :stripe_fingerprint
    add_index :bank_accounts, :country
    add_index :bank_accounts, :currency
    add_index :bank_accounts, :default_stripe_bank_account
  end
end
