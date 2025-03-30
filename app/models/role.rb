class Role < ApplicationRecord
  include Loggable
  has_many :users

  validates :name, presence: true, uniqueness: true
end
