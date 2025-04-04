class Purchase < ApplicationRecord
  include Loggable
  belongs_to :user
  belongs_to :item

  validates :purchase_date, presence: true
  validates :purchased_quantity, presence: true, numericality: { greater_than: 0 }

  scope :search, ->(query) {
    if query.present?
      joins(:item)
      .joins("LEFT JOIN categories ON items.category_id = categories.id")
      .where(
        'LOWER(items.description) LIKE :query OR
         LOWER(items.location) LIKE :query OR
         LOWER(categories.name) LIKE :query',
        query: "%#{query.downcase}%"
      )
    else
      all
    end
  }

  def self.sort_by_field(field, direction)
    direction = %w[asc desc].include?(direction) ? direction : "desc"

    case field
    when "item_description"
      joins(:item).order("items.description #{direction}")
    when "location"
      joins(:item).order("items.location #{direction}")
    when "category"
      joins(item: :category).order("categories.name #{direction}")
    when "purchased_quantity"
      order(purchased_quantity: direction)
    else
      order(created_at: direction)
    end
  end
end
