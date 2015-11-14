class Admin::FundsController < AdminController
  before_action :set_fund, only: [:show, :edit, :update, :destroy]

  # GET /funds
  def index
    @funds = Fund.all
    add_breadcrumb "Fundraisers"
  end

  # GET /funds/:id
  def show
  end

  # GET /funds/new
  def new
    @fund = Fund.new
  end

  # GET /funds/:id/edit
  def edit
  end

  # POST /funds
  def create
    @fund = Fund.new(fund_params)

    if @fund.save
      redirect_to @fund, notice: 'Fund was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /funds/:id
  def update
    if @fund.update(fund_params)
      redirect_to @fund, notice: 'Fund was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /funds/:id
  def destroy
    @fund.destroy
    redirect_to funds_url, notice: 'Fund was successfully destroyed.'
  end

  private

  def set_fund
    @fund = Fund.find(params[:id])
  end

  def fund_params
    params.require(:fund).permit(
      :uid,
      :user_id,
      :account_id,
      :name,
      :category,
      :description,
      :ends_at,
      :goal,
      :slug,
      :statement_descriptor,
      :state,
      :org_contributions,
      :website,
      :street,
      :apt_suite,
      :city,
      :state,
      :postal_code,
      :country,
      :reciept_message,
      :thank_you_reply_to,
      :thank_you_subject,
      :thank_you_body,
      :avatar,
      :header,
      :primary_color
    )
  end
end
