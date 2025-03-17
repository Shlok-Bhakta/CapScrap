class Renting < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :checkout_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :return_date_after_checkout_date, if: -> { return_date.present? }

  private

  scope :search, ->(query) {
    if query.present?
      joins(:user, :item)
        .where("users.email ILIKE :query OR items.name ILIKE :query", 
                q: "%#{query}%")
    else
      all
    end
  }

  scope :sort_by_field, ->(field, direction) {
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
  }

  def return_date_after_checkout_date
    if return_date.present? && checkout_date.present? && return_date < checkout_date
      errors.add(:return_date, "must be after the checkout date")
    end
  end
end
