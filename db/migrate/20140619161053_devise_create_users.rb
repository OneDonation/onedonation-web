class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string  :uid
      t.string  :username
      t.string  :email,              null: false, default: ""
      t.string  :stripe_customer_id
      t.string  :stripe_account_id
      t.string  :stripe_default_source
      t.string  :stripe_statement_descriptor
      t.jsonb   :stripe_tos_acceptance, null: false, default: '{}'
      t.jsonb   :stripe_legal_entity,  null: false, default: '{}'
      t.jsonb   :stripe_verification,  null: false, default: '{}'
      t.integer :stripe_verification_status
      t.string  :stripe_currency
      t.string  :encrypted_stripe_secret_key
      t.string  :encrypted_stripe_publishable_key
      t.integer :status, default: 0, null: false
      t.string  :prefix
      t.string  :first_name
      t.string  :middle_name
      t.string  :last_name
      t.string  :suffix
      t.integer :age
      t.integer :gender
      t.integer :entity_type
      t.string  :business_name
      t.string  :business_url
      t.string  :encrypted_business_tax_id
      t.string  :encrypted_business_vat_id
      t.string  :business_line1
      t.string  :business_line2
      t.string  :business_city
      t.string  :business_state
      t.string  :business_postal_code
      t.string  :business_country
      t.string  :user_phone
      t.string  :user_line1
      t.string  :user_line2
      t.string  :user_city
      t.string  :user_state
      t.string  :user_postal_code
      t.string  :user_country
      t.string  :encrypted_ssn_last_4
      t.string  :dob_month
      t.string  :dob_day
      t.string  :dob_year
      t.string  :timezone
      t.integer :account_type, default: 0
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :gender
    add_index :users, :age
    add_index :users, :uid,                  unique: true
    add_index :users, :email,                unique: true
    add_index :users, :username,             unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    add_index :users, :user_country
    add_index :users, :business_country
    add_index :users, :account_type
    add_index :users, :stripe_currency
    add_index :users, :stripe_account_id
    add_index :users, :stripe_tos_acceptance, using: :gin
    add_index :users, :stripe_legal_entity, using: :gin
    add_index :users, :stripe_verification, using: :gin
    add_index :users, :stripe_verification_status
    add_index :users, :status
  end
end
