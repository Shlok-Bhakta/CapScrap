class Item < ApplicationRecord
  include Loggable
  belongs_to :category
  has_many :rentings
  has_many :users, through: :rentings
  has_many :purchases
  has_many :purchasers, through: :purchases, source: :user

  validates :description, presence: true
  validates :location, presence: true

  validates :description, uniqueness: {
    scope: :location,
    message: "with that location already exists."
  }

  # searches for item by name
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }

  # fuzzy search for item by name
  scope :search, ->(query) {
    if query.present?
      where("LOWER(description) LIKE :query OR LOWER(location) LIKE :query",
            query: "%#{query.downcase}%")
        .joins(:category)
        .or(
          where("LOWER(categories.name) LIKE :query", query: "%#{query.downcase}%")
        )
    else
      all
    end
  }

  scope :sort_by_field, ->(field, direction) {
    # Return to default sort if no field or direction
    return order(created_at: :desc) if field.blank? || direction.blank?

    case field
    when "description"
      order(description: direction)
    when "location"
      order(location: direction)
    when "category"
      joins(:category).order("categories.name #{direction}")
    when "created_at"
      order(created_at: direction)
    else
      order(created_at: :desc)
    end
  }
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image

      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
