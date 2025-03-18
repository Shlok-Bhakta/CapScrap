# Porting the Users Table to Other Tables

This guide explains how to adapt the existing users table implementation (with search, sort, and pagination) to other tables like items or rentings.

## Step 1: Add Model Scopes

Add these scopes to your model (e.g. `app/models/item.rb` or `app/models/renting.rb`):

```ruby
def self.search(query)
  if query.present?
    # Customize these fields for your model
    where("name ILIKE :query OR description ILIKE :query", 
          query: "%#{query}%")
  else
    all
  end
end

def self.sort_by_field(field, direction)
  return order(created_at: :desc) if field.blank?

  direction = direction.to_s.downcase == 'desc' ? 'desc' : 'asc'
  
  # Add cases for each sortable column
  case field
  when 'name'
    order(name: direction)
  when 'price'
    order(price: direction)
  when 'created_at'
    order(created_at: direction)
  else
    order(created_at: :desc)
  end
end
```

## Step 2: Create the Table Partial

Create `_items_table.html.erb` or `_rentings_table.html.erb`:

```erb
<div class="flex flex-col">
  <table class="w-full">
    <thead>
      <tr class="border-b">
        <th class="p-2 text-left">
          <%= sort_header('name', 'Name', sort_field, sort_direction) %>
        </th>
        <th class="p-2 text-left">
          <%= sort_header('price', 'Price', sort_field, sort_direction) %>
        </th>
        <!-- Add more sortable columns as needed -->
        <th class="p-2 text-left">Actions</th>
      </tr>
    </thead>
    <tbody>
      <% records.each do |record| %>
        <tr class="border-b hover:bg-gray-50">
          <td class="p-2"><%= record.name %></td>
          <td class="p-2"><%= number_to_currency(record.price) %></td>
          <!-- Add your edit/delete actions here -->
          <td class="p-2">
            <%= link_to "Edit", 
                edit_item_path(record), 
                class: "text-primary hover:text-primary/80" %>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>

  <% if records.any? %>
    <%= pagination_nav(pagy) %>
  <% else %>
    <p class="text-center text-gray-500 mt-4">No records found</p>
  <% end %>
</div>
```

## Step 3: Create the Main View

Create your main view (e.g. `items.html.erb` or `rentings.html.erb`):

```erb
<div class="flex flex-col w-full h-full">
  <%= form_with url: admin_dashboard_items_path, 
                method: :get,
                data: { 
                  turbo_frame: "items_table",
                  turbo_action: "advance" 
                } do |f| %>
    <%= f.text_field :query,
        placeholder: "Search items...",
        class: "mb-4 p-2 border rounded",
        data: {
          controller: "search",
          action: "input->search#search"
        } %>
  <% end %>

  <%= turbo_frame_tag "items_table" do %>
    <%= render partial: "items_table",
              locals: {
                records: @items,
                pagy: @pagy,
                sort_field: params[:sort],
                sort_direction: params[:direction]
              } %>
  <% end %>
</div>
```

## Step 4: Update Controller

Add to your controller (e.g. `admin/dashboard_controller.rb`):

```ruby
def items
  @items_query = Item.search(params[:query])
                    .sort_by_field(params[:sort], params[:direction])
  @pagy, @items = pagy(@items_query)
  
  respond_to do |format|
    format.html
    format.turbo_stream { 
      render turbo_stream: turbo_stream.replace(
        "items_table", 
        partial: "admin/dashboard/items_table", 
        locals: { 
          records: @items,
          pagy: @pagy,
          sort_field: params[:sort],
          sort_direction: params[:direction]
        }
      )
    }
  end
end
```

## Key Points to Remember

1. Change these names to match your model:
   - Table partial name (e.g. `_items_table.html.erb`)
   - Turbo frame ID (e.g. `items_table`)
   - Form URL (e.g. `admin_dashboard_items_path`)
   - Variable names (e.g. `@items`)

2. Customize these for your table:
   - Search fields in the model's `search` method
   - Sortable columns in `sort_by_field`
   - Table columns and their display format
   - Actions column based on available operations

3. Keep these the same:
   - Pagination helper usage
   - Sort header helper usage
   - Search controller behavior
   - Turbo stream response structure

## Example: Rentings Table

For a rentings table, you might have:

```ruby
# app/models/renting.rb
def self.search(query)
  if query.present?
    joins(:user, :item)
      .where("users.email ILIKE :q OR items.name ILIKE :q", 
             q: "%#{query}%")
  else
    all
  end
end

def self.sort_by_field(field, direction)
  direction = direction.to_s.downcase == 'desc' ? 'desc' : 'asc'
  
  case field
  when 'user'
    joins(:user).order("users.email #{direction}")
  when 'item'
    joins(:item).order("items.name #{direction}")
  when 'start_date'
    order(start_date: direction)
  else
    order(created_at: :desc)
  end
end
```

Just adapt the search fields and sort columns to match your model's attributes and relationships.