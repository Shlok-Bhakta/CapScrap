class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :item
  
  validates :purchase_date, presence: true
  validates :purchased_quantity, presence: true, numericality: { greater_than: 0 }
end
