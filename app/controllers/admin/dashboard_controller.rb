class Admin::DashboardController < ApplicationController
  def users
    @users = User.search(params[:query]).joins(:role)
    @roles = Role.all.collect { |role| [ role.name, role.id ] }

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "users_table",
          partial: "admin/dashboard/users_table",
          locals: { users: @users, roles: @roles }
        )
      }
    end
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
