class DonationsController < ApplicationController
  before_action :set_donation, only: [:show, :edit, :update, :destroy]
  before_action :set_fund, only: [:create]
  before_action :set_recipient, only: [:create]

  helper_method :sort, :direction

  ZERO_DECIMAL_CURRENCIES = %w{BIF CLP DJF GNF JPY KMF KRW MGA PYG RWF VND VUV XAF XOF XPF}

  # GET /donations/:id
  def show
  end

  # GET /donations/new
  def new
    @donation = Donation.new
  end

  # GET /donations/:id/edit
  def edit
  end

  # POST /donations
  def create
    if valid_captcha_response?
      logger.debug 'valid response'
      initialize_donation
      set_charge_attributes
      begin
        @stripe_charge = Stripe::Charge.create(@charge_attributes)
        if @stripe_charge.status == "succeeded"
          logger.debug "Charge succeeded"
          @donation.set_stripe_data_and_save(@stripe_charge, @fees, params)
          logger.debug @donation.errors.full_messages
          # TODO: Redirect to Thank you page
          redirect_to donations_path(@donation), notice: "Donation successful..."
        else
          logger.debug "charge failed"
          # TODO: What to do if the donation doesn't save in our db?
          # Redirect to charge cleanup page
           redirect_to user_fund_path(@donation.recipient, @donation.fund), alert: "Stripe charge failed."
        end
      rescue Stripe::CardError => e
        logger.debug "Error creating charge due to: #{e.param} #{e.code}"
        parameter = e.param || "charge"
        logger.debug "Charge attributes: #{@charge_attributes.inspect}"
        @donation.errors.add(parameter, e.message)
        logger.debug @donation.errors.inspect
      rescue Stripe::RateLimitError => e
        logger.debug "Stripe Rate limit"
        logger.debug e.code
        logger.debug e.param
        logger.debug e.message
      rescue *[Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::APIError] => e
        logger.debug "Stripe API Error"
        logger.debug e.code
        logger.debug e.param
        logger.debug e.message
      end
    else
      logger.debug "invalid captcha"
      # TODO: Redirect or do something when the donation fails
    end
  end

  # PATCH/PUT /donations/:id
  def update
    if @donation.update(donation_params)
      redirect_to @donation, notice: 'Donation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /donations/:id
  def destroy
    @donation.destroy
    redirect_to donations_url, notice: 'Donation was successfully destroyed.'
  end


  def verify_captcha
    response = HTTParty.get("https://www.google.com/recaptcha/api/siteverify?secret=#{Rails.application.secrets.captcha_secret}&response=#{params[:captcha_token]}")
    if response.parsed_response["success"]
      render json: { status: "success", response: response.parsed_response }, status: :ok
    else
      render json: { status: "failed", response: response.parsed_response }, status: :unprocessable_entity
    end
  end

  private

  def set_donation
    @donation = Donation.find(params[:id])
  end

  def set_fund
    @fund = Fund.find(params[:fund_id])
  end

  def set_recipient
    @recipient = @fund.owner
  end

  def donation_params
    params.require(:donation).permit(
      :uid,
      :user_id,
      :donor_id,
      :fund_id,
      :stripe_id,
      :livemode,
      :paid,
      :status,
      :amount,
      :currency,
      :refunded,
      :source,
      :captured,
      :balance_transaction,
      :failure_message,
      :failure_code,
      :amount_refunded,
      :customer,
      :invoice,
      :description,
      :dispute,
      :metadata,
      :statement_descriptor,
      :fraud_details,
      :receipt_email,
      :receipt_number,
      :destination,
      :application_fee
    )
  end

  def set_charge_attributes
    # Set Card Token
    set_card_token
    # Set amount_in_cents and fees
    set_amount_and_fees(@fund.currency)
    @charge_attributes = {
      currency:         @fund.currency,
      amount:           @fees[:amount_in_cents],
      application_fee:  @fees[:application_fee_in_cents],
      source:           @card_token,
      description:      "Donation to #{@recipient.name("human")} - #{@fund.name}",
      destination:      @recipient.stripe_account_id,
      expand:           ['balance_transaction']
    }
  end

  # initialize a donation with or without a donor
  def initialize_donation
    if user_signed_in?
      @donation = @fund.donations.new(
                    recipient_id: @recipient.id,
                    donor_id: current_user,
                    stripe_customer_id: current_user.stripe_customer_id,
                    remote_ip: request.remote_ip
                  )
    else
      @donation = @fund.donation.new(recipient_id: @recipient.id)
    end
  end

  # Create a new source on the existing customer if they chose to save this card.
  # otherwise just grab stripe_token form params
  def set_card_token
    @card_token = if user_signed_in? && params[:save_card]
                    begin
                      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
                      @stripe_customer.sources.create(
                        source: params[:stripe_token]
                      ).id
                    rescue Stripe::APIError => e
                      Rails.logger.debug "Error retrieving customer: current_user.stripe_customer_id"
                      Rails.logger.debug e.inspect
                    end
                  else
                    params[:stripe_token]
                  end
  end

  def set_amount_and_fees(currency)
    @fees = Hash.new
    # Find base amount in cents in the charge currency
    donation_amount = if ZERO_DECIMAL_CURRENCIES.include?(currency)
                        params[:amount].to_i
                      else
                        params[:amount].to_i * 100
                      end
    @fees[:amount_in_cents] = Money.new(donation_amount, currency).cents
    # Convert to USD
    @fees[:amount_in_cents_usd] = if currency == "USD"
                                    @fees[:amount_in_cents]
                                  else
                                    Money.new(@fees[:amount_in_cents], currency).exchange_to("USD").cents
                                  end

    # Set fee variables in USD
    # Round up to ensure we don't rob ourselves of a cent.
    @fees[:stripe_fee_in_cents_usd]      = Money.new(((@fees[:amount_in_cents_usd] * 0.029) + 30).round, "USD").cents
    @fees[:onedonation_fee_in_cents_usd] = Money.new((@fees[:amount_in_cents_usd] * 0.03).round, "USD").cents
    @fees[:application_fee_in_cents_usd] = Money.new(@fees[:stripe_fee_in_cents_usd] + @fees[:onedonation_fee_in_cents_usd], "USD").cents
    @fees[:received_in_cents_usd]        = Money.new(@fees[:amount_in_cents_usd] - @fees[:application_fee_in_cents_usd], "USD").cents

    # Set charge fees variable in relevant currency
    if currency == "USD"
      @fees[:stripe_fee_in_cents]      = @fees[:stripe_fee_in_cents_usd]
      @fees[:onedonation_fee_in_cents] = @fees[:onedonation_fee_in_cents_usd]
      @fees[:application_fee_in_cents] = @fees[:application_fee_in_cents_usd]
      @fees[:received_in_cents]        = @fees[:received_in_cents_usd]

    else # Non US currency apply exchange rates to determine fees.
      @fees[:stripe_fee_in_cents]      = Money.new(@fees[:stripe_fee_in_cents_usd], "USD").exchange_to(currency).cents
      @fees[:onedonation_fee_in_cents] = Money.new(@fees[:onedonation_fee_in_cents_usd], "USD").exchange_to(currency).cents
      @fees[:application_fee_in_cents] = Money.new(@fees[:application_fee_in_cents_usd], "USD").exchange_to(currency).cents
      @fees[:received_in_cents]        = Money.new(@fees[:received_in_cents_usd], "USD").exchange_to(currency).cents
    end
  end


  def valid_captcha_response?
    md5 = Digest::MD5.new
    md5.update(params["g-recaptcha-response"] + Rails.application.secrets.stripe_public_key)
    params[:xlvm] == md5.to_s
  end
end
