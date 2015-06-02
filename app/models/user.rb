class User < ActiveRecord::Base
  include Tokenable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, omniauth_providers: [:stripe_connect]

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

  # Enums
  #########################
  enum gender: [:male, :female]

  # Relationships
  #########################
  has_many :addresses, ->       { where meta_type: 0 }
  has_many :emails, ->          { where meta_type: 1 }
  has_many :phones, ->          { where meta_type: 2 }
  has_many :websites, ->        { where meta_type: 3 }
  has_many :social_accounts, -> { where meta_type: 4 }
  has_many :dates, ->           { where meta_type: 5 }
  has_many :metadata, class_name: "Metadata", dependent: :destroy

  has_many :accounts, foreign_key: :owner_id, dependent: :destroy

  has_many :donations, dependent: :destroy
  has_many :funds, through: :accounts

  has_many :owned_accounts, class_name: "Account", foreign_key: "owner_id"
  has_one :current_account, -> { where(current: true) }, class_name: "Account", foreign_key: :owner_id

  accepts_nested_attributes_for :accounts#, allow_blank: false

  def donors(order_by = nil)
    donations.includes(:donors).donors.order(order_by).uniq
  end

  def recieved_donations
    Donation.where(fund_id: funds.pluck(:id), user_id: id)
  end

  def donations
    Donation.by_person(id)
  end

  def donated_funds
    Fund.by_donor(id)
  end

  # Scopes
  #########################

  # Validations
  #########################

  # Class Methods
  #########################

  def name(size)
  	case size
  	when "formal"
  		"#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}"
  	when "semi-formal"
  		"#{first_name} #{middle_name.present? ? middle_name[0].capitalize+"." : nil} #{last_name}"
  	when "human"
  		"#{first_name} #{last_name}"
  	end
  end

  def has_multiple_accounts?
    accounts.count > 1
  end

  def fundraising?
    funds.any?
  end

end
