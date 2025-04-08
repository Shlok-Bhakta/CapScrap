class Category < ApplicationRecord
  include Loggable
  has_many :items

  validates :name, presence: true, uniqueness: true
end
