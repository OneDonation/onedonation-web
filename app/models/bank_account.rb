class BankAccount < ActiveRecord::Base
  #                                Attributes
  # ----------------------------------------------------------------------------------
  # |              Name            |       Type        |         Description         |
  # | ---------------------------- | ----------------- | --------------------------- |
  # | :uid                         |     :string       |                             |
  # | :user_id                     |     :integer      |                             |
  # | :nickname                    |     :string       |                             |
  # | :stripe_account_id           |     :string       |                             |
  # | :stripe_bank_account_id      |     :string       |                             |
  # | :stripe_bank_account_last4   |     :string       |                             |
  # | :stripe_fingerprint          |     :string       |                             |
  # | :country                     |     :string       |                             |
  # | :currency                    |     :string       |                             |
  # | :default                     |     :boolean      |                             |
  # ----------------------------------------------------------------------------------
  include Tokenable

  # Enums
  #########################


  # Relationships
  #########################
  belongs_to :user

  # Scopes
  #########################
  scope :complete, -> { where.not(stripe_bank_account_id: nil) }

  # Validations
  #########################
  validates :country, presence: true, inclusion: { in: STRIPE_COUNTRIES }
  validates_presence_of :nickname, :user_id, :currency, :stripe_bank_account_id, :stripe_bank_account_last4, :stripe_fingerprint

  # Class Methods
  #########################

end
