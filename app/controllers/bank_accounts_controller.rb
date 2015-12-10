class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]
  before_action :retrieve_stripe_account, only: [:create, :update, :destroy]
  before_action :retrieve_stripe_bank_account, only: [:update, :destroy]

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
    if @bank_account.save_with_stripe(@stripe_account, params[:stripe_token])
      redirect_to profile_path("bank-accounts"), notice: t('.notice')
    else
      logger.debug @bank_account.errors.full_messages
      redirect_to profile_path("bank-accounts"), notice: t('.alert')
    end
  end

  # PATCH/PUT /bank_accounts/1
  def update
    if @bank_account.update_with_stripe(@stripe_bank_account, bank_account_params)
      redirect_to profile_path("bank-accounts"), notice: t('.notice')
    else
      logger.debug @bank_account.errors.full_messages
      redirect_to profile_path("bank-accounts"), notice: t('.alert')
    end
  end

  # DELETE /bank_accounts/1
  def destroy
    ensure_no_assign_funds
    if @bank_account.destroy_with_stripe(@stripe_bank_account)
      redirect_to profile_path("bank-accounts"), notice: t('.notice')
    else
      logger.debug @bank_account.errors.full_messages
      redirect_to profile_path("bank-accounts"), notice: t('.alert')
    end
  end

  private

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

  def ensure_no_assign_funds
    redirect_back_or_default alert: t("bank_accounts.errors.funds_present") unless !@bank_account.funds.any?
  end

  # Stripe Helper methods
  ########################################################################
  def retrieve_stripe_bank_account
    begin
      @stripe_bank_account = @stripe_account.external_accounts.retrieve(@bank_account.stripe_bank_account_id)
    rescue Stripe::InvalidRequestError => e
      redirect_back_or_default alert: "Sorry we where unable to find a Bank Account matching: #{params[:id]}"
    end
  end
end
