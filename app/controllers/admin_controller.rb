class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise_admin"
    else
      "admin"
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:update) { |a| a.permit(
                                                :name,
                                                :email,
                                                :password,
                                                :password_confirmation
                                              )
                                            }
  end
end
