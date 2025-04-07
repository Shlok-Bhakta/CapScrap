class Renting < ApplicationRecord
  include Loggable
  belongs_to :user
  belongs_to :item

  # Callbacks moved to use before_* to ensure quantity is available before saving
  before_create :check_available_quantity
  before_update :check_return_status_change

  validates :checkout_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :return_date_after_checkout_date, if: -> { return_date.present? }
  validate :sufficient_item_quantity, on: :create

  private

  scope :search, ->(query) {
    if query.present?
      joins(:user, :item)
        .where("users.email ILIKE :query OR items.description ILIKE :query OR rentings.quantity::text ILIKE :query",
                query: "%#{query}%")
    else
      all
    end
  }

  scope :sort_by_field, ->(field, direction) {
    direction = direction.to_s.downcase == "desc" ? "desc" : "asc"

    case field
    when "user"
      joins(:user).order("users.email #{direction}")
    when "item"
      joins(:item).order("items.description #{direction}")
    when "quantity"
      order(quantity: direction)
    when "checkout_date"
      order(checkout_date: direction)
    when "return_date"
      order(return_date: direction)
    else
      order(created_at: :desc)
    end
  }
def return_date_after_checkout_date
  if return_date.present? && checkout_date.present? && return_date < checkout_date
    errors.add(:return_date, "must be after the checkout date")
  end
end

def sufficient_item_quantity
  if item.present? && quantity.present?
    purchased = Purchase.where(item_id: item_id).sum(:purchased_quantity)
    rented = Renting.where(item_id: item_id)
                   .where(is_returned: false)
                   .where.not(id: id)
                   .sum(:quantity)
    available_quantity = purchased - rented

    if quantity > available_quantity
      errors.add(:quantity, "exceeds available quantity (#{available_quantity} available)")
    end
  end
end

private

def check_available_quantity
  # Same calculation as in sufficient_item_quantity
  purchased = Purchase.where(item_id: item_id).sum(:purchased_quantity)
  rented = Renting.where(item_id: item_id)
                 .where(is_returned: false)
                 .where.not(id: id)
                 .sum(:quantity)
  available_quantity = purchased - rented

  if quantity > available_quantity
    errors.add(:quantity, "exceeds available quantity (#{available_quantity} available)")
    throw(:abort)
  end
end

def check_return_status_change
  if saved_change_to_is_returned? && !is_returned
    # If changing from returned to not returned, check if quantity is available
    check_available_quantity
  end
end
end
