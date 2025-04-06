class Renting < ApplicationRecord
  include Loggable
  belongs_to :user
  belongs_to :item

  validates :checkout_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :return_date_after_checkout_date, if: -> { return_date.present? }

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
end
