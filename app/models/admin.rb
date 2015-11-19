class Admin < ActiveRecord::Base
  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :uid                    |     :string       |                             |
  # | :name                   |     :string       |                             |
  # | :email                  |     :string       |                             |
  # | :permission             |     :integer      |                             |
  # | :encrypted_password     |     :string       |                             |
  # | :reset_password_token   |     :string       |                             |
  # | :reset_password_sent_at |     :datetime     |                             |
  # | :remember_created_at    |     :datetime     |                             |
  # | :sign_in_count          |     :string       |                             |
  # | :current_sign_in_at     |     :datetime     |                             |
  # | :last_sign_in_at        |     :datetime     |                             |
  # | :current_sign_in_ip     |     :string       |                             |
  # | :last_sign_in_ip        |     :string       |                             |
  # | :confirmation_token     |     :string       |                             |
  # | :confirmed_at           |     :datetime     |                             |
  # | :confirmation_sent_at   |     :datetime     |                             |
  # | :unconfirmed_email      |     :string       |                             |
  # | :failed_attempts        |     :string       |                             |
  # | :unlock_token           |     :string       |                             |
  # | :locked_at              |     :datetime     |                             |
  # -----------------------------------------------------------------------------

  include Tokenable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :lockable

  # Enums
  #########################
  enum permission: {
    admin: 0,
    employee: 1,
    support: 2
  }

  # Relationships
  #########################

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

end
