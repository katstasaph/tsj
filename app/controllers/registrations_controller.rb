class Devise::RegistrationsController
 before_action :configure_permitted_parameters

 def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up) do |user_params|
   user_params.permit(:first_name, :last_name, :username,
    :email, :password, :password_confirmation, :name, :url, :wp_username, :wp_password)
  end
  devise_parameter_sanitizer.permit(:account_update) do |user_params|
   user_params.permit(:first_name, :last_name, :username,
    :email, :password, :password_confirmation, :name, :url, :wp_username, :wp_password)
  end
 end
end