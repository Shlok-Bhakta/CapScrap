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
    data = JSON.parse(request.body.read)["item"]
    @item = Item.find(data["id"])
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
    # Default sorting by creation date if no sort params
    params[:sort] ||= "created_at"
    params[:direction] ||= "desc"

    @purchases_query = Purchase.includes(item: :category)
                             .search(params[:query])
                             .sort_by_field(params[:sort], params[:direction])

    @pagy, @purchases = pagy(@purchases_query, items: params[:per_page] || 50)
    @categories = Category.all

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "content",
          partial: "admin/dashboard/purchases_table",
          locals: {
            purchases: @purchases,
            sort_field: params[:sort],
            sort_direction: params[:direction],
            pagy: @pagy
          }
        )
      }
    end
  end

  def search_items
    return render json: { error: "Query required" }, status: :unprocessable_entity if params[:query].blank?

    query = params[:query].downcase
    begin
      # Find exact matches first
      exact_matches = Item.includes(:category)
                        .where("LOWER(description) = ?", query)

      # Then find partial matches, excluding exact matches
      partial_matches = Item.includes(:category)
                          .where("LOWER(description) LIKE ?", "%#{query}%")
                          .where.not(id: exact_matches.select(:id))

      # Combine results with exact matches first
      @items = (exact_matches + partial_matches).first(5)

      render json: {
        items: @items.map { |i| {
          id: i.id,
          description: i.description,
          location: i.location,
          category: i.category.name
        }}
      }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_purchase
    ActiveRecord::Base.transaction do
      if params[:item_query].present?
        # Try to find existing item
        @item = Item.find_by("LOWER(description) = ?", params[:item_query].downcase)

        # Create new item if not found
        unless @item
          @item = Item.create!(
            description: params[:item_query],
            location: params[:location],
            category_id: params[:category_id]
          )
        end
      end

      @purchase = Purchase.new(
        item: @item,
        purchased_quantity: params[:purchased_quantity],
        user: current_user,
        purchase_date: Time.current
      )

      if @purchase.save
        redirect_to admin_dashboard_purchased_path, notice: "Purchase created successfully."
      else
        redirect_to admin_dashboard_purchased_path, alert: @purchase.errors.full_messages.join(", ")
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_dashboard_purchased_path, alert: e.message
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
