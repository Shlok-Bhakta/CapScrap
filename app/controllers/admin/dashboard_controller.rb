class Admin::DashboardController < ApplicationController
  before_action :check_professor_role

  def users
    @users_query = User.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
                      .joins(:role)
    @pagy, @users = pagy(@users_query, items: params[:per_page] || 50)
    @roles = Role.all.collect { |role| [ role.name, role.id ] }

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "users_table",
          partial: "admin/dashboard/users_table",
          locals: {
            users: @users,
            pagy: @pagy,
            roles: @roles,
            sort_field: params[:sort],
            sort_direction: params[:direction]
          }
        )
      }
    end
  end

  def items
    @items_query = Item.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
                      .joins(:category)
    @pagy, @items = pagy(@items_query, items: params[:per_page] || 50)
    @categories = Category.all

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "items_table",
          partial: "admin/dashboard/items_table",
          locals: {
            items: @items,
            pagy: @pagy,
            categories: @categories,
            sort_field: params[:sort],
            sort_direction: params[:direction]
          }
        )
      }
    end
  end

  def create_item
    @item = Item.new(item_params)
    if @item.save
      render json: { success: true, message: "Item created successfully" }
    else
      render json: {
        success: false,
        error: @item.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  def update_item
    # get data from body of data
    data = JSON.parse(request.body.read)["item"]
    puts "Data: #{data}"
    @item = Item.find(data["id"])
    puts "Item updated"
    if @item.update({ description: data["description"], location: data["location"], category_id: data["category_id"] })
      render json: { success: true, message: "Item updated successfully" }
    else
      render json: {
        success: false,
        error: @item.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  def delete_item
    @item = Item.find(params[:id])
    if @item.destroy
      render json: { success: true, message: "Item deleted successfully" }
    else
      render json: {
        success: false,
        error: "Failed to delete item this item is probably being used by someone"
      }, status: :unprocessable_entity
    end
  end


  def renting
  end

  def purchased
  end

  def update_user_role
    user = User.find(params[:user_id])
    if user.update(role_id: params[:role_id])
      render json: { success: true, message: "Role updated successfully" }
    else
      render json: { success: false, message: "Failed to update role" }, status: :unprocessable_entity
    end
  end

  private

  def check_professor_role
    unless current_user&.role_id == 3
      flash[:alert] = "You are not authorized to access this area"
      redirect_to root_path
    end
  end

  def item_params
    params.require(:item).permit(:description, :location, :category_id)
  end
end
