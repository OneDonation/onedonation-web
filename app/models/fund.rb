class Fund < ActiveRecord::Base
	include Tokenable

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

  # Enums
  #########################

  # Relationships
  #########################
  belongs_to :account
  belongs_to :user
  has_many :donations

  # Scopes
  #########################
  scope :by_donor, -> (user_id) { includes(:donations).where(donations: { donor_id: user_id }) }

  # Validations
  #########################

  # Class Methods
  #########################

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
