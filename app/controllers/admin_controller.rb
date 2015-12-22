class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!
  layout :layout_by_resource
  helper_method :sort_column,
                :sort_direction,
                :order_by,
                :default_sort,
                :default_direction,
                :resource_class


  protected

  def layout_by_resource
    if devise_controller?
      "devise_admin"
    else
      "admin"
    end
  end

  private

  def redirect_back_or_default(options = {})
    redirect_to (request.referer.present? ? :back : admin_dashboard_path), options
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:update) { |a| a.permit(
                                                :name,
                                                :email,
                                                :password,
                                                :password_confirmation
                                              )
                                            }
  end

  def default_sort
    "created_at"
  end

  def default_direction
    "asc"
  end

  def sort_column
    resource_class.column_names.include?(params[:sort]) ? params[:sort] : default_sort
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction
  end

  def order_by
    "#{sort_column} #{sort_direction}"
  end

  def resource_class
    controller_name.classify.constantize
  end

end
