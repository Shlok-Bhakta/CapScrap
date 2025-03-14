class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_devise_variables, if: :devise_controller?

  private

  def set_devise_variables
    @resource = resource_class.new if !user_signed_in? && request.path == new_user_session_path
    @resource_name = :user
  end
end
