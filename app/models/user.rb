class User < ApplicationRecord
  include Loggable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  belongs_to :role

  scope :search, ->(query) {
    if query.present?
      where("LOWER(full_name) LIKE :query OR LOWER(email) LIKE :query",
            query: "%#{query.downcase}%")
        .joins(:role)
        .or(
          where("LOWER(roles.name) LIKE :query", query: "%#{query.downcase}%")
        )
    else
      all
    end
  }

  scope :sort_by_field, ->(field, direction) {
    # Return to default sort if no field or direction
    return order(created_at: :desc) if field.blank? || direction.blank?

    case field
    when "name"
      order(full_name: direction)
    when "email"
      order(email: direction)
    when "role"
      joins(:role).order("roles.name #{direction}")
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
