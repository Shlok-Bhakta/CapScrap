class Admin::DashboardController < ApplicationController
  def users
    # get all users from the database joined with Role table joined by role_id = Role.id with reguklar post
    @users = User.joins(:role)
    @roles = Role.all.collect { |role| [ role.name, role.id ] }
    # print out the users
    puts @users
  end

  def items
  end

  def update_user_role
    # do nothing if user is not a professor
    unless current_user.role_id == 3
      render json: { success: false, message: "You are not authorized to update user roles" }, status: :unprocessable_entity
      return
    end
    user = User.find(params[:user_id])
    if user.update(role_id: params[:role_id])
      render json: { success: true, message: "Role updated successfully" }
    else
      render json: { success: false, message: "Failed to update role" }, status: :unprocessable_entity
    end
  end
end
