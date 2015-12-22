class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :bank_accounts, :edit, :update, :destroy]
  helper_method :selected_tab

  # GET /dashboard
  def dashboard
  end

  # GET /users
  def index
    @users = User.all.order("#{sort_column} #{sort_direction}")
  end

  # GET /users/:id
  def show
  end

  def bank_accounts
    @bank_accounts = @user.bank_accounts
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find_by(username: params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :first_name,
      :last_name,
      :user_line1,
      :user_line2,
      :user_city,
      :user_state,
      :business_name,
      :business_url,
      :business_tax_id,
      :business_vat_id,
      :business_line1,
      :business_line2,
      :business_city,
      :business_state
    )
  end

  def default_sort
    "first_name"
  end

  def selected_tab
    @selected_tab ||= params[:selected_tab]
  end
end
