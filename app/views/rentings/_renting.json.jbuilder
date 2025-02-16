json.extract! renting, :id, :user_id, :item_id, :checkout_date, :return_date, :quantity, :created_at, :updated_at
json.url renting_url(renting, format: :json)
