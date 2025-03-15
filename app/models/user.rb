class User < ApplicationRecord
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
