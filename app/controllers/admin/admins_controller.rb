class Admin::AdminsController < AdminController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  helper_method :sort, :direction

  # GET /dashboard
  def dashboard
  end

  # GET /admins
  def index
    @admins = Admin.all
  end

  # GET /admins/:id
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/:id/edit
  def edit
  end

  # POST /admins
  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to @admin, notice: 'Admin was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admins/:id
  def update
    if @admin.update(admin_params)
      redirect_to @admin, notice: 'Admin was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admins/:id
  def destroy
    @admin.destroy
    redirect_to admins_url, notice: 'Admin was successfully destroyed.'
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(
      :name,
      :email
    )
  end

  def sort
    Admin.column_names.include?(params[:sort].downcase) ? params[:sort].downcase : "admins.created_at"
  end

  def direction
    if params[:direction].present? && %w[asc desc].include?(params[:direction])
       params[:direction]
    else
      "asc"
    end
  end
end
