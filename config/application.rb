require_relative "boot"

require "rails/all"
require "logger"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Capscrap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")


    # Set up a rotating logger with a max file size of 10MB, keeping only 5 rotated files
    log_file = Rails.root.join("log", "application.log")
    logger = Logger.new(log_file, 5, 10 * 1024 * 1024) # 5 files, each max 10MB
    # Customize log format
    logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{progname}: #{msg}\n"
    end
    # Enable tagged logging
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    # Set logging level
    config.logger.level = Logger::INFO
  end
end
