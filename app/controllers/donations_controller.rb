class DonationsController < ApplicationController
  before_action :set_donation, only: [:show, :edit, :update, :destroy]
  helper_method :sort, :direction


  # GET /donations
  def index
    if params[:filter].present?
      @donations = current_user.donations.includes(:fund, :donor)

      if params[:name].present?
        name = params[:name].split
        @donations = @donations.where("lower(users.first_name) LIKE ? OR lower(users.last_name) LIKE ?", name[0].downcase, name[1].present? ? name[1].downcase : name[0].downcase)
      end

      if params[:email].present?
        @donations = @donations.where("lower(users.email) LIKE ?", params[:email].downcase)
      end

      if params[:fund].present?
        if params[:fund] == "incoming"
          @donations = @donations.where(funds: {uid: current_user.funds.collect{|f| f.uid}})
        elsif params[:fund] == "outgoing"
          @donations = @donations.where(funds: {uid: current_user.donated_funds.collect{|f| f.uid}})
        else
          @donations = @donations.where(funds: {uid: params[:fund]})
        end
      end

      if params[:amount].present?
        if params[:amount].match(/\.\./)
          amounts = params[:amount].split('..')
          final_amounts = Array.new
          amounts.each do |amount|
            amount = amount.gsub('$', '')
            final_amounts << Float(amount)*100
          end
          @donations = @donations.where(amount: final_amounts[0]..final_amounts[1])
        else
          amount = params[:amount].gsub('$', '')
          amount = Float(amount)*100
          @donations = @donations.where(amount: amount)
        end
      end

      if params[:status].present?
        case params[:status]
        when "cleared"
          @donations = @donations.cleared
        when "refunded"
          @donations = @donations.refunded
        end
      end

      if params[:date].present?
        dates = params[:date].split("-")
        start_date = Chronic.parse(dates[0])
        end_date = Chronic.parse(dates[1])
        @donations = @donations.where(created_at: start_date..end_date)
      end
      @donations = @donations.order(sort+ " " +direction).page(params[:page]).per(params[:per])
    else
      @donations = current_user.donations.includes(:fund, :donor).order(sort+ " " +direction).page(params[:page]).per(params[:per])
    end


    # if params[:fund].present?
    #   case params[:fund]
    #   when "all"
    #     @donations = Donation.includes(:fund, :donor).received_donations(current_user.funds.collect{|f| f.id }).order(sort+ " " +direction).page(params[:page]).per(params[:per])
    #   else
    #     @donations = current_user.funds.find_by(slug: params[:fund]).donations.includes(:fund, :donor).order(sort+ " " +direction).page(params[:page]).per(params[:per])
    #   end
    # else
    #   @donations = current_user.donations.includes(:fund, :donor).order(sort+ " " +direction).page(params[:page]).per(params[:per])
    # end
    add_breadcrumb "Donations", donations_path()
  end

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

  def sort
    if params[:sort].present?
      case params[:sort]
      when "Email"
        "users.email"
      when "Name"
        "users.first_name"
      when "Fund"
        "funds.name"
      else
        Donation.column_names.include?(params[:sort].downcase) ? params[:sort].downcase : "donations.created_at"
      end
    else
      "donations.created_at"
    end
  end

  def direction
    if params[:direction].present? && %w[asc desc].include?(params[:direction])
       params[:direction]
    else
      "asc"
    end
  end
end
