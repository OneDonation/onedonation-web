class Account < ActiveRecord::Base
  include Tokenable
  attr_encrypted :stripe_secret_key, key: Rails.application.secrets.encryption_key
  attr_encrypted :stripe_publishable_key, key: Rails.application.secrets.encryption_key

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |              Name             |       Type        |         Description         |
  # | ----------------------------- | ----------------- | --------------------------- |
  # | :uid                          |     :string       |                             |
  # | :slug                         |     :string       |                             |
  # | :owner_id                     |     :integer      |                             |
  # | :stripe_account_id            |     :string       |                             |
  # | :stripe_subscription_id       |     :string       |                             |
  # | :stripe_subscription_status   |     :string       |                             |
  # | :stripe_secret_key            |     :string       |                             |
  # | :stripe_publishable_key       |     :string       |                             |
  # | :stripe_plan_id               |     :string       |                             |
  # | :stripe_plan_name             |     :string       |                             |
  # | :email                        |     :string       |                             |
  # | :business_name                |     :string       |                             |
  # | :business_url                 |     :string       |                             |
  # | :support_phone                |     :string       |                             |
  # | :statement_descriptor         |     :string       |                             |
  # | :account_type                 |     :integer      |                             |
  # | :current                      |     :boolean      |                             |
  # -----------------------------------------------------------------------------

  # Enums
  #########################
  enum entity_type: [
    :donor,
    :personal,
    :business
  ]
  enum stripe_verification_status: [
    :unverified,
    :pending,
    :verified
  ]

  # Relationships
  #########################
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :funds, dependent: :destroy
  has_many :metadata, class_name: "Metadata"
  has_many :addresses, ->       { where meta_type: 0 }
  has_many :emails, ->          { where meta_type: 1 }
  has_many :phones, ->          { where meta_type: 2 }
  has_many :websites, ->        { where meta_type: 3 }
  has_many :social_accounts, -> { where meta_type: 4 }

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

  def to_param
    uid
  end

  def name
    case account_type
    when "personal"
      owner.name("human")
    when "oganization"
      business_name
    end

  end

  def has_stripe_id?
    stripe_account_id.present?
  end
end
