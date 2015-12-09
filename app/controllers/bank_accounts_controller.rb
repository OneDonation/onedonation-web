class BankAccountsController < ApplicationController
  before_action :retrieve_stripe_account
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]

  # GET /bank_accounts/1
  def show
  end

  # GET /bank_accounts/new
  def new
    @bank_account = BankAccount.new
  end

  # GET /bank_accounts/1/edit
  def edit
  end

  # POST /bank_accounts
  def create
    @bank_account = current_user.bank_accounts.new(bank_account_params)
    create_bank_account_from_token

    if @bank_account.save
      redirect_to profile_path("bank-accounts"), notice: t('.notice')
    else
      render :new
    end
  end

  # PATCH/PUT /bank_accounts/1
  def update
    if @bank_account.update(@bank_account_attributes)
      redirect_to @bank_account, notice: t('.notice')
    else
      render :edit
    end
  end

  # DELETE /bank_accounts/1
  def destroy
    @bank_account.destroy
    redirect_to bank_accounts_url, notice: t('.notice')
  end

  private

  def create_bank_account_from_token
    begin
      # Create bank account in stripe from token
      @stripe_bank_account = @stripe_account.external_accounts.create(
                               external_account: params[:stripe_token]
                             )
      # Store account details in @bank_account object
      @bank_account.stripe_bank_account_id     = @stripe_bank_account.id
      @bank_account.stripe_bank_account_last4  = @stripe_bank_account.last4
      @bank_account.stripe_fingerprint         = @stripe_bank_account.fingerprint
    rescue *[Stripe::APIConnectionError, Stripe::AuthenticationError, Stripe::APIError] => e
      # TODO: Add to NewRelic
      Rails.logger.debug "Error creating bank account in stripe for account: #{current_user.stripe_account_id}"
      redirect_back_or_default notice: t("stripe.errors.api_html")
    rescue Stripe::RateLimitError => e
      # TODO: alert user of rate limit issues they should wait a minute and try again.
      redirect_back_or_default notice: t("stripe.errors.rate_limit_html")
    end
  end

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(
      :nickname,
      :country,
      :currency,
      :default_stripe_bank_account
    )
  end
end
