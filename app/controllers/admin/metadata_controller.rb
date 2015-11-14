class Admin::MetadataController < AdminController
  before_action :set_user_metum, only: [:show, :edit, :update, :destroy]

  # GET /metadata
  def index
    @metadata = Metadata.all
  end

  # GET /metadata/:id
  def show
  end

  # GET /metadata/new
  def new
    @metadata = Metadata.new
  end

  # GET /metadata/:id/edit
  def edit
  end

  # POST /metadata
  def create
    @metadata = Metadata.new(user_metum_params)

    if @metadata.save
      redirect_to @metadata, notice: 'User metum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /metadata/:id
  def update
    if @Mmtadata.update(user_metum_params)
      redirect_to @metadata, notice: 'User metum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /metadata/:id
  def destroy
    @metadata.destroy
    redirect_to metadata_url, notice: 'User metum was successfully destroyed.'
  end

  private

  def set_user_metum
    @metadata = Metadata.find_by(params[:uid])
  end

  def user_metum_params
    params.require(:metadata).permit(
      :uid,
      :account_id,
      :user_id,
      :name,
      :meta_type,
      :meta_sub_type,
      :custom,
      :date,
      :street,
      :apt_suite,
      :city,
      :state,
      :postal_code,
      :country,
      :email_address,
      :number,
      :username,
      :value
    )
  end
end
