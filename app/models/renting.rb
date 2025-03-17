class Renting < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :checkout_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :return_date_after_checkout_date, if: -> { return_date.present? }

  after_update :remove_single_use_item, if: :returned?
  private

  def return_date_after_checkout_date
    if return_date.present? && checkout_date.present? && return_date < checkout_date
      errors.add(:return_date, "must be after the checkout date")
    end
  end

  # Removes the item from inventory if it is marked as single-use
  def remove_single_use_item
    if item.single_use?
      Rails.logger.info "Removing single-use item: #{item.id} (#{item.description})"
      item.destroy
    end
  end

  # Checks if an item has been returned
  def returned?
    return_date.present?
  end
end
