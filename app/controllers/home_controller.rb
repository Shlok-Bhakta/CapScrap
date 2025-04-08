class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      # Redirect based on user role
      case current_user.role_id
      when 1 # Student
        redirect_to student_dashboard_items_path
      when 2 # Teaching Assistant
        redirect_to ta_dashboard_renting_path
      when 3 # Teacher/Admin
        redirect_to admin_dashboard_renting_path
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end 