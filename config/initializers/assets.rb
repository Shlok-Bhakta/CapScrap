# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Enable debug mode in development for live reloading
Rails.application.config.assets.debug = Rails.env.development?

# Enable automatic asset compilation in development
Rails.application.config.assets.compile = Rails.env.development?

# Don't cache assets in development
Rails.application.config.assets.configure do |env|
  env.cache = ActiveSupport::Cache::NullStore.new if Rails.env.development?
end

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
