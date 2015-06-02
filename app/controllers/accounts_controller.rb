class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy]
  skip_before_action :check_account_complete?, only: [:setup]
  helper_method :setting

  # GET /accounts
  def index
    @accounts = Account.all
  end

  # GET /accounts/:id
  def show
    add_breadcrumb "Settings", settings_path("profile")
    add_breadcrumb setting.capitalize if setting.present?
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/:id/edit
  def edit
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # GET /accounts/:id/setup
  def setup
  end

  # PATCH/PUT /accounts/:id
  def update
    if @account.update(account_params)
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /accounts/:id
  def destroy
    @account.destroy
    redirect_to accounts_url, notice: 'Account was successfully destroyed.'
  end

  private

  def setting
    params[:setting]
  end

  def set_account
    @account = Account.find_by(uid: params[:id]) || Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(
      :uid,
      :slug,
      :owner_id,
      :stripe_account_id,
      :stripe_subscription_id,
      :stripe_subscription_status,
      :stripe_secret_key,
      :stripe_publishable_key,
      :stripe_plan_id,
      :stripe_plan_name,
      :email,
      :business_name,
      :business_url,
      :support_phone,
      :statement_descriptor,
      :account_type
    )
  end
end
