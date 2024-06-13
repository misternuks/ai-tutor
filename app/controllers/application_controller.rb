class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  def ensure_admin!
    redirect_to(root_path, alert: "You are not authorized to perform this action.") unless current_user.admin?
  end

  def ensure_instructor_or_admin!
    redirect_to(root_path, alert: "You are not authorized to perform this acdtion.") unless current_user.instructor? || current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :admin, :instructor])
  end

  def json_request?
    request.format.json?
  end
end
