class Student::DashboardController < ApplicationController
  before_action :check_student_role

  def items
    @items_query = Item.search(params[:query])
                      .sort_by_field(params[:sort], params[:direction])
                      .joins(:category)
    @pagy, @items = pagy(@items_query, items: params[:per_page] || 50)

    # Calculate and attach purchased quantity to each item
    @items.each do |item|
      purchased_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity) - Renting.where(item_id: item.id).where(is_returned: false).sum(:quantity)
      total_quantity = Purchase.where(item_id: item.id).sum(:purchased_quantity)

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
          partial: "student/dashboard/items_table",
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

  private

  def check_student_role
    return if current_user&.role_id == 1
    redirect_to root_path, alert: "You are not authorized to view this page"
  end
end