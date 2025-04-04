# config/initializers/database_action_logger.rb
require "logger"
log_dir = Rails.root.join("log")
FileUtils.mkdir_p(log_dir) unless File.directory?(log_dir)
db_logger_path = log_dir.join("#{Rails.env}_database_actions.log")

# Set up log rotation (keeps 5 files of 100MB each)
DATABASE_LOGGER = ActiveSupport::TaggedLogging.new(
  Logger.new(db_logger_path, 5, 100.megabytes)
)

# Optional: Set log level
DATABASE_LOGGER.level = Logger::INFO
