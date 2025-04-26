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

    # Calculate and attach purchased quantity to each item
    @items.each do |item|
      purchased_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity) - Renting.where(item_id: item.id).where(is_returned: false).sum(:quantity)
      total_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity)

      # Dynamically add a quantity method to each item object
      item.define_singleton_method(:quantity) do
        purchased_quantity
      end
      item.define_singleton_method(:total_quantity) do
        total_quantity
      end
    end

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

  def renting
    @rentings_query = Renting.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
    @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)
    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "rentings_table",
          partial: "admin/dashboard/rentings_table",
          locals: {
            pagy: @pagy,
            sort_field: params[:sort],
            sort_direction: params[:direction]
          }
        )
      }
    end
  end

  def update_quantity
    @renting = Renting.find(params[:id])
    if @renting.update(quantity_params)
      respond_to do |format|
        format.json { render json: { success: true } }
        format.turbo_stream {
          @rentings_query = Renting.search(params[:query]).sort_by_field(params[:sort], params[:direction])
          @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "admin/dashboard/rentings_table",
            locals: {
              rentings: @rentings,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction]
            }
          )
        }
        format.html { redirect_to admin_dashboard_renting_path, notice: "Quantity updated." }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, error: @renting.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "admin/dashboard/rentings_table",
            locals: {
              rentings: Renting.all,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction]
            }
          ), status: :unprocessable_entity
        }
        format.html { redirect_to admin_dashboard_renting_path, alert: @renting.errors.full_messages.join(", ") }
      end
    end
  end

  def toggle_renting
    @renting = Renting.find(params[:id])
    success = true

    begin
      ActiveRecord::Base.transaction do
        @renting.toggle(:is_returned)

        if @renting.is_returned
          @renting.update!(return_date: Date.today)
        else
          # When un-returning, validate available quantity
          purchased = Purchase.where(item_id: @renting.item_id).sum(:purchased_quantity)
          rented = Renting.where(item_id: @renting.item_id)
                         .where(is_returned: false)
                         .where.not(id: @renting.id)
                         .sum(:quantity)
          available = purchased - rented

          if @renting.quantity > available
            raise ActiveRecord::RecordInvalid.new(@renting),
                  "Cannot un-return: only #{available} items available"
          end

          @renting.update!(return_date: nil)
        end

        @renting.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      success = false
      flash[:error] = e.message
    end

    if success
      @rentings_query = Renting.search(params[:query])
                        .sort_by_field(params[:sort], params[:direction])
      @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

      respond_to do |format|
        format.html { redirect_to admin_dashboard_renting_path }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "admin/dashboard/rentings_table",
            locals: {
              rentings: @rentings,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction],
              flash: flash
            }
          )
        }
      end
    else
      @rentings_query = Renting.search(params[:query])
                        .sort_by_field(params[:sort], params[:direction])
      @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

      respond_to do |format|
        format.html {
          redirect_to admin_dashboard_renting_path,
          alert: flash[:error]
        }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "admin/dashboard/rentings_table",
            locals: {
              rentings: @rentings,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction],
              flash: flash
            }
          )
        }
      end
    end
  end

  def toggle_singleuse
    @renting = Renting.find(params[:id])
    @renting.toggle!(:is_singleuse)

    @rentings_query = Renting.search(params[:query])
                    .sort_by_field(params[:sort], params[:direction])
    @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

    respond_to do |format|
      format.html { redirect_to admin_dashboard_renting_path }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "rentings_table",
          partial: "admin/dashboard/rentings_table",
          locals: {
            rentings: @rentings,
            pagy: @pagy,
            sort_field: params[:sort],
            sort_direction: params[:direction]
          }
        )
      }
    end
  rescue => e
    respond_to do |format|
      format.html {
        flash[:error] = "Error updating single use: #{e.message}"
        redirect_to admin_dashboard_renting_path
      }
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "flash",
          html: "Error updating single use: #{e.message}"
        )
      }
    end
  end

  def add_comment
    renting = Renting.find(params[:id])
    comment_text = params[:comment]

    renting.update(comments: comment_text)

    respond_to do |format|
      format.html { redirect_to admin_dashboard_renting_path, notice: "Comment saved!" }
      format.turbo_stream { head :ok }
    end
  end


  def delete_renting
    @renting = Renting.find(params[:id])
    success = @renting.destroy

    # Always fetch rentings for the table
    @rentings_query = Renting.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
    @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

    respond_to do |format|
      if success
        format.json { render json: { success: true } }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "admin/dashboard/rentings_table",
            locals: {
              rentings: @rentings,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction]
            }
          )
        }
      else
        format.json { render json: { success: false, error: "Failed to delete renting" }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.update("flash", html: "Error deleting renting: Failed to delete"),
            turbo_stream.replace(
              "rentings_table",
              partial: "admin/dashboard/rentings_table",
              locals: {
                rentings: @rentings,
                pagy: @pagy,
                sort_field: params[:sort],
                sort_direction: params[:direction]
              }
            )
          ]
        }
      end
    end
  end

  def create_renting
    ActiveRecord::Base.transaction do
      user = User.find_by("LOWER(full_name) = ?", params[:user].downcase)
      item = Item.find_by("LOWER(description) = ?", params[:item].downcase)

      if !user
        redirect_to admin_dashboard_renting_path, alert: "User not found" and return
      end

      if !item
        redirect_to admin_dashboard_renting_path, alert: "Item not found" and return
      end

      # Check available quantity before creating the renting
      purchased = Purchase.where(item_id: item.id).sum(:purchased_quantity)
      rented = Renting.where(item_id: item.id)
                     .where(is_returned: false)
                     .sum(:quantity)
      available = purchased - rented

      if available <= 0
        message = "exceeds available quantity (#{available} available)"
        respond_to do |format|
          format.html { redirect_to admin_dashboard_renting_path, alert: message }
          format.turbo_stream {
            render turbo_stream: turbo_stream.update("flash",
              html: "Quantity #{message}"),
              status: :unprocessable_entity
          }
        end
        return
      end

      @renting = Renting.new(
        user: user,
        item: item,
        quantity: params[:quantity],
        is_singleuse: params[:is_singleuse],
        checkout_date: Date.today,
        return_date: nil,
        is_returned: false,
      )

      if @renting.save
        @rentings_query = Renting.search(params[:query])
                        .sort_by_field(params[:sort], params[:direction])
        @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

        respond_to do |format|
          format.html { redirect_to admin_dashboard_renting_path, notice: "Renting created successfully." }
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace(
              "rentings_table",
              partial: "admin/dashboard/rentings_table",
              locals: {
                rentings: @rentings,
                pagy: @pagy,
                sort_field: params[:sort],
                sort_direction: params[:direction]
              }
            )
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_dashboard_renting_path, alert: @renting.errors.full_messages.join(", ") }
          format.turbo_stream {
            render turbo_stream: turbo_stream.update(
              "flash",
              html: @renting.errors.full_messages.join(", ")
            )
          }
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { redirect_to admin_dashboard_renting_path, alert: e.message }
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "flash",
          html: e.message
        )
      }
    end
  end

  def search_users
    return render json: { error: "Query required" }, status: :unprocessable_entity if params[:query].blank?

    query = params[:query].downcase
    begin
      # Find exact matches first
      exact_matches = User.where("LOWER(full_name) = ?", query)

      # Then find partial matches, excluding exact matches
      partial_matches = User.where("LOWER(full_name) LIKE ? OR LOWER(email) LIKE ?", "%#{query}%", "%#{query}%")
                          .where.not(id: exact_matches.select(:id))

      # Combine results with exact matches first
      @users = (exact_matches + partial_matches).first(5)

      render json: {
        users: @users.map { |u| {
          id: u.id,
          full_name: u.full_name,
          email: u.email
        }}
      }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
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

  def create_item
    @item = Item.new(item_params)
    if @item.save
      render json: { success: true, message: "Item created successfully" }
    else
      render json: { success: false, error: @item.errors.full_messages.join(", ") }, status: :ok
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
    # Parse the request body for user_id and role_id
    data = JSON.parse(request.body.read)
    user_id = data["user_id"]
    role_id = data["role_id"]

    # Find the user
    @user = User.find_by(id: user_id)

    # Check if user exists
    unless @user
      return render json: { success: false, message: "User not found" }, status: :not_found
    end

    # Check if role exists
    unless Role.exists?(id: role_id)
      return render json: { success: false, message: "Role not found" }, status: :not_found
    end

    # Update the role
    if @user.update(role_id: role_id)
      render json: { success: true, message: "User role updated successfully" }
    else
      render json: {
        success: false,
        message: "Failed to update user role",
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def quantity_params
    params.require(:renting).permit(:quantity)
  end

  def item_params
    params.require(:item).permit(:description, :location, :category_id)
  end

  def check_professor_role
    # Allow Professor (3) and Teaching Assistant (2)
    return if current_user && [2, 3].include?(current_user.role_id)
    redirect_to root_path, alert: "You are not authorized to view this page"
  end
end
