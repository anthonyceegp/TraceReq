class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout

  def layout
  	devise_controller? && controller_name != "registrations" ? "devise" : "application"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:username, :avatar, :remove_avatar, :password, :password_confirmation, :current_password)
    end
  end
end
