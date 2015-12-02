class Fund < ActiveRecord::Base

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :uid                    |     :string       |                             |
  # | :user_id                |     :integer      |                             |
  # | :account_id             |     :integer      |                             |
  # | :name                   |     :string       |                             |
  # | :category               |     :integer      |                             |
  # | :description            |     :text         |                             |
  # | :close_date             |     :date         |                             |
  # | :goal                   |     :string       |                             |
  # | :slug                   |     :string       |                             |
  # | :charge_descripto       |     :string       |                             |
  # | :state                  |     :string       |                             |
  # | :org_contribution       |     :boolean      |                             |
  # | :website                |     :string       |                             |
  # | :street                 |     :string       |                             |
  # | :apt_suite              |     :string       |                             |
  # | :city                   |     :string       |                             |
  # | :postal_code            |     :string       |                             |
  # | :country                |     :string       |                             |
  # | :reciept_message        |     :text         |                             |
  # | :thank_you_reply_to     |     :string       |                             |
  # | :thank_you_subject      |     :string       |                             |
  # | :thank_you_body         |     :text         |                             |
  # | :avatar                 |     :string       |                             |
  # | :header                 |     :string       |                             |
  # | :primary_color          |     :string       |                             |
  # -----------------------------------------------------------------------------
  include Tokenable

  # Enums
  #########################
  enum category: {
    business: 0,
    charity: 1,
    community: 2,
    creative: 3,
    events: 4,
    faith: 5,
    family: 6,
    national_news: 7,
    newleyweds: 8,
    travel: 9,
    wish: 10,
    other: 11
  }

  enum status: {
    pending: 0,
    active: 1,
    cancelled: 2,
    complete: 3,
    suspended: 4
  }

  # Relationships
  #########################
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :donations

  # Scopes
  #########################
  scope :by_donor,    -> (donor_id) { where(donations: { donor_id: donor_id }) }
  scope :personal,    -> { where(group_fund: false) }
  scope :group_fund,  -> { where(group_fund: true) }

  # Validations
  #########################
  validates :owner_id, presence: true
  validates :url, presence: true, format: { with: /\A[0-9A-Za-z\-]+\z/ }

  # Class Methods
  #########################

  def to_param
    url
  end

  def currency
    owner.stripe_currency
  end

  def raised
    Float(donations.sum(:amount))/100
  end

  def pecent_raised
    ((raised/goal)*100).ceil
  end

  def goal
    Float(read_attribute(:goal))/100
  end
end
