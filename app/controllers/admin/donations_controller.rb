class Admin::DonationsController < AdminController
  before_action :set_donation, only: [:show, :view_payment, :edit, :update, :destroy]
  helper_method :sort, :direction


  # GET /donations
  def index
    @donations = Donation.all.includes(:donor, :recipient, :fund).order("#{order_by}").page(params[:page]).per(params[:per])
  end

  # GET /donations/:id
  def show
  end

  def view_payment
    @payment = Stripe::Charge.retrieve(
                 id: @donation.stripe_charge_id,
                 expand: [
                   'application_fee',
                   'balance_transaction',
                   'customer'
                 ]
               )
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
    @donation = Donation.new(donation_params)

    if @donation.save
      redirect_to @donation, notice: 'Donation was successfully created.'
    else
      render :new
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

  private

  def set_donation
    @donation = Donation.find(params[:id])
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

  def default_sort
    "donations.created_at"
  end

  def order_by
    case params[:sort]
    when "recipient"
      "recipients_donations.first_name #{sort_direction}, funds.name #{sort_direction}"
    else
      super
    end
  end
end
