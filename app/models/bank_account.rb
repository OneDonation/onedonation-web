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
  # | :default_stripe_bank_account |     :boolean      |                             |
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
  validates_presence_of :nickname, :user_id, :currency

  # Class Methods
  #########################

  # Ensures the base object is valid, creates the Stripe resource,
  # grabs the Stripe resource id and other useful info, then saves the object.
  def save_with_stripe(stripe_account, token)
    begin
      if valid?
        # Create bank account in stripe from token
        stripe_bank_account = stripe_account.external_accounts.create(external_account: token)
        # Store stripe_bank_account details
        self.stripe_bank_account_id     = stripe_bank_account.id
        self.stripe_bank_account_last4  = stripe_bank_account.last4
        self.stripe_fingerprint         = stripe_bank_account.fingerprint
        self.save
      else
        false
      end
    rescue *[Stripe::APIError, Stripe::InvalidRequestError] => exception
      case exception.http_status
      when 400 # Bad request - The request was unacceptable, often due to missing a required parameter.
        self.errors.add(:stripe, exception.message)
      when 404 # Not Found - The requested resource doesn't exist."
        self.errors.add(:stripe, exception.message)
      when 500, 502, 503, 504 # Server Errors - Something went wrong on Stripe's end. (These are rare.)
        self.errors.add(:stripe, t("stripe.errors.server_errors_html"))
      end
      false
    end
  end

  # Ensures the base object is valid, updates the resource in stripe, then saves the object.
  def update_with_stripe(stripe_bank_account, params)
    begin
      self.attributes = params
      if valid?
        stripe_bank_account.default_for_currency = ['true', '1', 'yes', 'on', 't', 1, true].include?(params[:default_stripe_bank_account])
        stripe_bank_account.save
        self.save
      else
        false
      end
    rescue *[Stripe::APIError, Stripe::InvalidRequestError] => exception
      case exception.http_status
      when 400 # Bad request - The request was unacceptable, often due to missing a required parameter.
        self.errors.add(:stripe, exception.message)
      when 404 # Not Found - The requested resource doesn't exist."
        self.errors.add(:stripe, exception.message)
      when 500, 502, 503, 504 # Server Errors - Something went wrong on Stripe's end. (These are rare.)
        self.errors.add(:stripe, t("stripe.errors.server_errors_html"))
      end
      false
    end
  end

  # Delete the Stripe resource, then deletes the object
  def destroy_with_stripe(stripe_bank_account)
    begin
      stripe_bank_account.delete
      self.destroy
    rescue Stripe::APIError => exception
      self.errors.add(:stripe, t("stripe.errors.server_errors_html"))
      false
    end
  end

end
