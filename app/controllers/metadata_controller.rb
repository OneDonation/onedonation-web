class UserMetaController < ApplicationController
  before_action :set_user_metum, only: [:show, :edit, :update, :destroy]

  # GET /user_meta
  # GET /user_meta.json
  def index
    @user_meta = UserMetum.all
  end

  # GET /user_meta/1
  # GET /user_meta/1.json
  def show
  end

  # GET /user_meta/new
  def new
    @user_metum = UserMetum.new
  end

  # GET /user_meta/1/edit
  def edit
  end

  # POST /user_meta
  # POST /user_meta.json
  def create
    @user_metum = UserMetum.new(user_metum_params)

    respond_to do |format|
      if @user_metum.save
        format.html { redirect_to @user_metum, notice: 'User metum was successfully created.' }
        format.json { render :show, status: :created, location: @user_metum }
      else
        format.html { render :new }
        format.json { render json: @user_metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_meta/1
  # PATCH/PUT /user_meta/1.json
  def update
    respond_to do |format|
      if @user_metum.update(user_metum_params)
        format.html { redirect_to @user_metum, notice: 'User metum was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_metum }
      else
        format.html { render :edit }
        format.json { render json: @user_metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_meta/1
  # DELETE /user_meta/1.json
  def destroy
    @user_metum.destroy
    respond_to do |format|
      format.html { redirect_to user_meta_url, notice: 'User metum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_metum
      @user_metum = UserMetum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_metum_params
      params[:user_metum]
    end
end
