class Donation < ActiveRecord::Base

  #                                Attributes
  # -----------------------------------------------------------------------------
  # |           Name          |       Type        |         Description         |
  # | ----------------------- | ----------------- | --------------------------- |
  # | :user_id                |     :string       |                             |
  # | :donor_id               |     :string       |                             |
  # | :fund_id                |     :integer      |                             |
  # | :string_id              |     :string       |                             |
  # | :string_customer_id     |     :string       |                             |
  # | :stripe_invoice_id      |     :string       |                             |
  # | :description            |     :string       |                             |
  # | :captured               |     :boolean      |                             |
  # | :paid                   |     :boolean      |                             |
  # | :refunded               |     :boolean      |                             |
  # | :amount                 |     :integer      |                             |
  # | :amount_refunded        |     :integer      |                             |
  # | :currency               |     :string       |                             |
  # | :stripe_card_id         |     :string       |                             |
  # | :card_last_four         |     :string       |                             |
  # | :card_brand             |     :string       |                             |
  # | :card_exp_month         |     :string       |                             |
  # | :card_exp_year          |     :string       |                             |
  # | :stripe_failure_message |     :string       |                             |
  # | :stripe_failure_code    |     :string       |                             |
  # | :statement_description  |     :string       |                             |
  # -----------------------------------------------------------------------------
  include Tokenable

  # Enums
  #########################

  # Relationships
  #########################
  belongs_to :donor, class_name: "User", foreign_key: "donor_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :designated_user, class_name: "User", foreign_key: "designated_to"
  belongs_to :fund

  # Scopes
  #########################
  scope :cleared,    -> { where(captured: true, refunded: false) }
  scope :refunded,   -> { where(refunded: true) }
  scope :by_person,  -> (user_id) { where("donations.donor_id = :person_id OR donations.user_id = :person_id", person_id: user_id) }

  # Validations
  #########################
  validates :amount_in_cents, presence: true
  validates :recipient_id, presence: true, unless: Proc.new { |donation| donation.designated_to.present? }
  validates :fund_id, presence: true

  # Class Methods
  #########################

  def state
    if stripe_paid && !stripe_refunded
      "Cleared"
    elsif stripe_refunded
      "Refunded"
    end
  end

  def set_stripe_data_and_save(stripe_charge, fees)
    # Fees
    self.amount_in_cents              = fees[:amount_in_cents]
    self.stripe_fee_in_cents          = fees[:stripe_fee_in_cents]
    self.onedonation_fee_in_cents              = fees[:onedonation_fee_in_cents]
    self.aggregated_fee_in_cents      = fees[:application_fee_in_cents]
    self.amount_in_cents_usd          = fees[:amount_in_cents_usd]
    self.stripe_fee_in_cents_usd      = fees[:stripe_fee_in_cents_usd]
    self.onedonation_fee_in_cents_usd          = fees[:onedonation_fee_in_cents_usd]
    self.aggregated_fee_in_cents_usd  = fees[:application_fee_in_cents_usd]

    # Stripe charge attributes
    self.stripe_customer_id           = stripe_charge.customer
    self.stripe_charge_id             = stripe_charge.id
    self.stripe_source_id             = stripe_charge.source.id
    self.stripe_destination           = stripe_charge.destination
    self.stripe_amount_refunded       = stripe_charge.amount_refunded
    self.stripe_application_fee_id    = stripe_charge.application_fee
    self.stripe_balance_transaction   = stripe_charge.balance_transaction.to_json
    self.stripe_captured              = stripe_charge.captured
    self.stripe_created               = stripe_charge.created
    self.stripe_currency              = stripe_charge.currency
    self.stripe_description           = stripe_charge.description
    self.stripe_dispute               = stripe_charge.dispute.to_json
    self.stripe_failure_code          = stripe_charge.failure_code
    self.stripe_failure_message       = stripe_charge.failure_message
    self.stripe_fraud_details         = stripe_charge.fraud_details.to_json
    self.stripe_metadata              = stripe_charge.metadata.to_json
    self.stripe_paid                  = stripe_charge.paid
    self.stripe_receipt_number        = stripe_charge.receipt_number
    self.stripe_refunded              = stripe_charge.refunded
    self.stripe_refunds               = stripe_charge.refunds.to_json
    self.stripe_source                = stripe_charge.source.to_json
    self.stripe_statement_descriptor  = stripe_charge.statement_descriptor
    self.stripe_status                = stripe_charge.status
    self.save
  end

end
