module Admin::DashboardHelper
  def sort_header(field, display_name, current_sort, current_direction)
    next_direction = if current_sort != field
                      "asc"  # First click on a new column
    elsif current_direction == "asc"
                      "desc" # Switch to descending
    elsif current_direction == "desc"
                      nil    # Third click: remove sorting
    else
                      "asc"  # No current direction
    end

    link_class = "flex items-center space-x-2 group"
    link_class += " text-primary" if current_sort == field

    up_arrow_class = "text-gray-400 group-hover:text-gray-600"
    up_arrow_class = "text-secondary" if current_sort == field && current_direction == "asc"

    down_arrow_class = "text-gray-400 group-hover:text-gray-600"
    down_arrow_class = "text-secondary" if current_sort == field && current_direction == "desc"

    # Only include sort params if we're not returning to default state
    path_params = if next_direction.nil?
                   { query: params[:query] }
    else
                   { sort: field, direction: next_direction, query: params[:query] }
    end

    arrows_html = content_tag(:div, class: "flex flex-col ml-4") do
      safe_join([
        content_tag(:span, "▲", class: up_arrow_class),
        content_tag(:span, "▼", class: down_arrow_class)
      ])
    end

    link_to admin_dashboard_users_path(path_params),
           class: link_class,
           data: { turbo_frame: "users_table" } do
      tag.div(class: "flex items-center") do
        safe_join([ display_name, arrows_html ])
      end
    end
  end
end
