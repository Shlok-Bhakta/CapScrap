class User < ApplicationRecord
  belongs_to :role
  has_many :rentings
  has_many :items, through: :rentings
  has_many :purchases
  has_many :purchased_items, through: :purchases, source: :item

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  def name
    "#{first_name} #{last_name}"
  end
end
