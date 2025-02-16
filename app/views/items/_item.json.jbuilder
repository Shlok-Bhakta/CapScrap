json.extract! item, :id, :category_id, :description, :location, :created_at, :updated_at
json.url item_url(item, format: :json)
