# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location = stored_location_for(resource_or_scope)
    return stored_location if stored_location

    # Redirect based on user role
    case resource_or_scope.role_id
    when 1 # Student
      student_dashboard_items_path
    when 2 # Teaching Assistant
      admin_dashboard_renting_path # Redirect TAs to admin dashboard
    when 3 # Teacher/Admin
      admin_dashboard_renting_path
    else
      root_path
    end
  end
  # protected


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
