json.extract! purchase, :id, :user_id, :item_id, :purchase_date, :purchased_quantity, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
