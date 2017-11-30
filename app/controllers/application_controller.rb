class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  layout :layout

  def layout
  	devise_controller? ? "devise" : "application"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

end
