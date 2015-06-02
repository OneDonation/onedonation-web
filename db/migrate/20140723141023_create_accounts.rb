class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :uid
      t.string :slug
      t.integer :owner_id
      t.string :stripe_account_id
      t.string :encrypted_stripe_secret_key
      t.string :encrypted_stripe_publishable_key
      t.integer :stripe_verification_status
      t.string :stripe_subscription_id
      t.string :stripe_subscription_status
      t.string :stripe_plan_id
      t.string :stripe_plan_name
      t.string :email
      t.string :country
      t.string :business_name
      t.string :business_url
      t.string :support_phone
      t.string :statement_descriptor
      t.integer :account_type, default: 0
      t.boolean :current, default: false

      t.timestamps
    end

    add_index :accounts, :uid, unique: true
    add_index :accounts, :owner_id
    add_index :accounts, :slug, unique: true
    add_index :accounts, :email
    add_index :accounts, :country
    add_index :accounts, :stripe_plan_id
    add_index :accounts, :stripe_account_id
    add_index :accounts, :stripe_subscription_id
    add_index :accounts, :stripe_verification_status
  end
end