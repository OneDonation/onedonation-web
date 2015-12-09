class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]
  before_action :configure_permitted_parameters
  helper_method :setting, :step

  # GET /resource/sign_up
  def new
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      resource.create_stripe_customer(request)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def onboarding_step
    @resource = current_user
  end

  def onboarding_progress
    @resource = current_user
    resource_updated = @resource.update_without_password(account_update_params)

    if resource_updated
      @resource.create_stripe_account(request.user_agent, request.remote_ip)
      redirect_to onboarding_step_path, notice: "account created"
    else
      render :onboarding_step
    end
  end

  def update_stripe
    @resource = current_user
    resource_updated = @resource.update_without_password(account_update_params)

    if resource_updated
      @resource.update_stripe_account(request)
      redirect_to onboarding_step_path, notice: "account created"
    else
      render :onboarding_step
    end
  end

  def finalize_account
    create_stripe_account(resource, request)
  end

  # GET /resource/edit
  def edit
    case setting
    when "bank-accounts"
      @bank_account = current_user.bank_accounts.build
    end
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    onboarding_step_path()
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  def translation_scope
    'devise.registrations'
  end

  def setting
    params[:setting]
  end

  def step
    @step ||= params[:step]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(
                                                 :account_type,
                                                 :country,
                                                 :email,
                                                 :password,
                                                 :password_confirmation
                                               )
                                             }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(
                                                      :username,
                                                      :email,
                                                      :first_name,
                                                      :last_name,
                                                      :prefix,
                                                      :first_name,
                                                      :middle_name,
                                                      :last_name,
                                                      :suffix,
                                                      :age,
                                                      :gender,
                                                      :business_name,
                                                      :business_url,
                                                      :encrypted_business_tax_id,
                                                      :encrypted_business_vat_id,
                                                      :business_line1,
                                                      :business_line2,
                                                      :business_city,
                                                      :business_state,
                                                      :business_postal_code,
                                                      :business_country,
                                                      :user_phone,
                                                      :user_line1,
                                                      :user_line2,
                                                      :user_city,
                                                      :user_state,
                                                      :user_postal_code,
                                                      :user_country,
                                                      :user_phone,
                                                      :ssn_last_4,
                                                      :dob_month,
                                                      :dob_day,
                                                      :dob_year,
                                                      :country,
                                                      :timezone,
                                                      :account_type,
                                                      :password,
                                                      :password_confirmation
                                                      )
                                                    }
  end

  def create_stripe_account(resource, params, request)
    begin
      stripe_account = Stripe::Account.create(
                                        country: resource.first.country,
                                        email: resource.email,
                                        legal_entity: params[:legal_entity],
                                        tos_acceptance: {
                                          date: Time.now.to_i,
                                          ip: request.remote_ip
                                        }
                                      )
      resource.update(
        stripe_account_id: stripe_account.id,
        stripe_secret_key: stripe_account.keys.secret,
        stripe_publishable_key: stripe_account.keys.publishable,
        stripe_legal_entity: stripe_account.legal_entity,
        stripe_verification: stripe_account.legal_entity.verification,
        stripe_tos_acceptance: stripe_account.tos_acceptance
      )
    rescue Stripe::APIError => e
      Rails.logger.debug e.inspect
      # TODO: Handle Stripe Errors at signup.
    end
  end

  # def update_without_password(params, *options)
  #   params.delete(:email)
  #   super(params)
  # end
end
