class Item < ApplicationRecord
  belongs_to :category
  has_many :rentings
  has_many :users, through: :rentings
  has_many :purchases
  has_many :purchasers, through: :purchases, source: :user

  validates :description, presence: true
  validates :location, presence: true
  
  #searches for item by name
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }
end

