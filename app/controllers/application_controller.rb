class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def json_request?
    request.format.json?
  end
end
