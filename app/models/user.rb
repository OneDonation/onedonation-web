class User < ActiveRecord::Base

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
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :lockable,
         :omniauthable,
         omniauth_providers: [ :stripe_connect ]

  # Enums
  #########################
  enum stripe_verification_status: {
    unverified: 0,
    pending: 1,
    verified: 2
  }
  enum gender: {
    male: 0,
    female: 1
  }

  # Relationships
  #########################
  has_many :addresses,        -> { where meta_type: 0 }
  has_many :emails,           -> { where meta_type: 1 }
  has_many :phones,           -> { where meta_type: 2 }
  has_many :websites,         -> { where meta_type: 3 }
  has_many :social_accounts,  -> { where meta_type: 4 }
  has_many :dates,            -> { where meta_type: 5 }
  has_many :metadata, class_name: "Metadata", dependent: :destroy
  has_many :donations, foreign_key: :recipient_id
  has_many :contributions, class_name: "Donation", foreign_key: :donor_id
  has_many :funds, foreign_key: "owner_id"
  has_many :memberships, dependent: :destroy
  has_many :group_funds, through: :memberships, foreign_key: :fund_id

  def donors(order_by = nil)
    User.where(id: donations.select(:donor_id).uniq)
  end

  def donated_funds
    Fund.by_donor(id)
  end

  # Scopes
  #########################

  # Validations
  #########################
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :username, uniqueness: true

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

end
