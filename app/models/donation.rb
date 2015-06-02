class Donation < ActiveRecord::Base
	include Tokenable

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :user_id                |     :string       |                             |
  # | :donor_id               |     :string       |                             |
  # | :fund_id                |     :integer      |                             |
  # | :string_id              |     :string       |                             |
  # | :string_customer_id     |     :string       |                             |
  # | :stripe_invoice_id			|     :string       |															|
  # | :description						|     :string       |															|
  # | :captured								|     :boolean      |															|
  # | :paid										|     :boolean      |															|
  # | :refunded								|     :boolean      |															|
  # | :amount									|     :integer      |															|
  # | :amount_refunded				|     :integer      |															|
  # | :currency								|     :string       |															|
  # | :stripe_card_id					|     :string       |															|
  # | :card_last_four					|     :string       |															|
  # | :card_brand							|     :string       |															|
  # | :card_exp_month					|     :string       |															|
  # | :card_exp_year					|     :string       |															|
  # | :stripe_failure_message	|     :string       |															|
  # | :stripe_failure_code		|     :string       |															|
  # | :statement_description	|     :string       |															|
  # -----------------------------------------------------------------------------

  # Enums
  #########################

  # Relationships
  #########################
	belongs_to :donor, class_name: "User", foreign_key: "donor_id"
	belongs_to :recipient, class_name: "user", foreign_key: "user_id"
	belongs_to :fund

	# Scopes
  #########################
	scope :cleared, -> 	{ where(captured: true, refunded: false) }
	scope :refunded, -> { where(refunded: true) }
  scope :by_person, -> (user_id) { where("donations.donor_id = :person_id OR donations.user_id = :person_id", person_id: user_id) }

  # Validations
  #########################

  # Class Methods
  #########################

	def state
		if paid && !refunded
			"Cleared"
		elsif refunded
			"Refunded"
		end
	end

end