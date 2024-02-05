class ApplicationController < ActionController::Base
  include Pundit::Authorization 

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include ActiveStorage::SetCurrent

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

 def configure_devise_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up) do |user_params|
   user_params.permit(:first_name, :last_name, :username,
    :email, :password, :password_confirmation, :current_password, :name, :url, :wp_username, :wp_password)
  end
  devise_parameter_sanitizer.permit(:account_update) do |user_params|
   user_params.permit(:first_name, :last_name, :username,
    :email, :password, :password_confirmation, :current_password, :name, :url, :wp_username, :wp_password)
  end
 end

end
