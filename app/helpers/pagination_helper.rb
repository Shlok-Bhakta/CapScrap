module PaginationHelper
  def pagination_nav(pagy)
    return unless pagy.pages > 1

    tag.nav(class: "mt-4") do
      tag.ul(class: "flex items-center justify-center gap-2") do
        safe_join([
          prev_link(pagy),
          page_links(pagy),
          next_link(pagy)
        ])
      end
    end
  end

  private

  def page_links(pagy)
    links = []

    # First page
    links << page_number(1, pagy.page == 1)

    # Gap after first page
    links << gap if pagy.page > 3

    # Pages around current
    from = [ 2, pagy.page - 1 ].max
    to = [ pagy.last - 1, pagy.page + 1 ].min
    (from..to).each do |number|
      links << page_number(number, number == pagy.page)
    end

    # Gap before last page
    links << gap if pagy.page < pagy.last - 2

    # Last page (if not first page)
    links << page_number(pagy.last, pagy.page == pagy.last) if pagy.last > 1

    links
  end

  def page_number(number, current = false)
    link_class = "px-3 py-1.5 rounded text-sm font-medium"
    link_class += current ? " bg-primary/10 text-primary" : " text-gray-600 hover:bg-gray-100"

    tag.li do
      link_to number,
              url_for(request.params.merge(page: number)),
              class: link_class,
              data: { turbo_frame: "users_table" }
    end
  end

  def gap
    tag.li(class: "px-2 text-gray-500") do
      "..."
    end
  end

  def prev_link(pagy)
    tag.li do
      if pagy.prev
        link_to url_for(request.params.merge(page: pagy.prev)),
                class: "flex items-center px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 rounded font-medium",
                data: { turbo_frame: "users_table" } do
          "← Prev"
        end
      else
        tag.span "← Prev",
                 class: "flex items-center px-3 py-1.5 text-sm text-gray-400 cursor-not-allowed font-medium"
      end
    end
  end

  def next_link(pagy)
    tag.li do
      if pagy.next
        link_to url_for(request.params.merge(page: pagy.next)),
                class: "flex items-center px-3 py-1.5 text-sm text-gray-600 hover:bg-gray-100 rounded font-medium",
                data: { turbo_frame: "users_table" } do
          "Next →"
        end
      else
        tag.span "Next →",
                 class: "flex items-center px-3 py-1.5 text-sm text-gray-400 cursor-not-allowed font-medium"
      end
    end
  end
end
