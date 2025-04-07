class Ta::DashboardController < ApplicationController
  helper Ta::DashboardHelper
  before_action :check_ta_role
  respond_to :html, :json, :turbo_stream

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
          partial: "ta/dashboard/users_table",
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

    @items.each do |item|
      purchased_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity) - Renting.where(item_id: item.id).where(is_returned: false).sum(:quantity)
      total_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity)

      item.define_singleton_method(:quantity) { purchased_quantity }
      item.define_singleton_method(:total_quantity) { total_quantity }
    end

    @categories = Category.all

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "items_table",
          partial: "ta/dashboard/items_table",
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
          partial: "ta/dashboard/rentings_table",
          locals: {
            rentings: @rentings,
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
            partial: "ta/dashboard/rentings_table",
            locals: {
              rentings: @rentings,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction]
            }
          )
        }
        format.html { redirect_to ta_dashboard_renting_path, notice: "Quantity updated." }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, error: @renting.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "ta/dashboard/rentings_table",
            locals: {
              rentings: Renting.all,
              pagy: @pagy,
              sort_field: params[:sort],
              sort_direction: params[:direction]
            }
          ), status: :unprocessable_entity
        }
        format.html { redirect_to ta_dashboard_renting_path, alert: @renting.errors.full_messages.join(", ") }
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
        format.html { redirect_to ta_dashboard_renting_path }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "ta/dashboard/rentings_table",
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
          redirect_to ta_dashboard_renting_path,
          alert: flash[:error]
        }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "ta/dashboard/rentings_table",
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
      format.html { redirect_to ta_dashboard_renting_path }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "rentings_table",
          partial: "ta/dashboard/rentings_table",
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
        redirect_to ta_dashboard_renting_path
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
      format.html { redirect_to ta_dashboard_renting_path, notice: "Comment saved!" }
      format.turbo_stream { head :ok }
    end
  end

  def delete_renting
    @renting = Renting.find(params[:id])
    success = @renting.destroy

    @rentings_query = Renting.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
    @pagy, @rentings = pagy(@rentings_query, items: params[:per_page] || 50)

    respond_to do |format|
      if success
        format.json { render json: { success: true } }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rentings_table",
            partial: "ta/dashboard/rentings_table",
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
              partial: "ta/dashboard/rentings_table",
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
        redirect_to ta_dashboard_renting_path, alert: "User not found" and return
      end

      if !item
        redirect_to ta_dashboard_renting_path, alert: "Item not found" and return
      end

      purchased = Purchase.where(item_id: item.id).sum(:purchased_quantity)
      rented = Renting.where(item_id: item.id)
                     .where(is_returned: false)
                     .sum(:quantity)
      available = purchased - rented

      if available <= 0
        message = "exceeds available quantity (#{available} available)"
        respond_to do |format|
          format.html { redirect_to ta_dashboard_renting_path, alert: message }
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
          format.html { redirect_to ta_dashboard_renting_path, notice: "Renting created successfully." }
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace(
              "rentings_table",
              partial: "ta/dashboard/rentings_table",
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
          format.html { redirect_to ta_dashboard_renting_path, alert: @renting.errors.full_messages.join(", ") }
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
      format.html { redirect_to ta_dashboard_renting_path, alert: e.message }
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

      respond_to do |format|
        format.json {
          render json: {
            users: @users.map { |u| {
              id: u.id,
              full_name: u.full_name,
              email: u.email
            }}
          }
        }
      end
    rescue StandardError => e
      respond_to do |format|
        format.json {
          render json: { error: e.message }, status: :unprocessable_entity
        }
      end
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

      respond_to do |format|
        format.json {
          render json: {
            items: @items.map { |i| {
              id: i.id,
              description: i.description,
              location: i.location,
              category: i.category.name
            }}
          }
        }
      end
    rescue StandardError => e
      respond_to do |format|
        format.json {
          render json: { error: e.message }, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def check_ta_role
    return if current_user&.role_id == 2
    redirect_to root_path, alert: "You are not authorized to view this page"
  end

  def quantity_params
    params.require(:renting).permit(:quantity)
  end
end
