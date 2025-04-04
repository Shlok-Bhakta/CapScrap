class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_current_user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def log_view(resource)
    # user = current_user ? "#{current_user.id} (#{current_user.email})" : "Guest User"

    # if defined?(DATABASE_LOGGER)
    #   DATABASE_LOGGER.tagged("VIEW_ACTION", resource.class.name) do
    #     DATABASE_LOGGER.info("VIEW | User: #{user} | ID: #{resource.id}")
    #   end
    # else
    #   Rails.logger.tagged("VIEW_ACTION", resource.class.name) do
    #     Rails.logger.info("VIEW | User: #{user} | ID: #{resource.id}")
    #   end
    # end
    resource = instance_variable_get("@#{controller_name.singularize}")
    return unless resource # Skip if no resource found

    # user = current_user_identifier
    user = current_user
    timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")

    if defined?(DATABASE_LOGGER)
      DATABASE_LOGGER.tagged("VIEW_ACTION", resource.class.name) do
        DATABASE_LOGGER.info("VIEW | Time: #{timestamp} | User: #{user} | ID: #{resource.id}")
      end
    else
      # Fallback to standard Rails logger
      Rails.logger.tagged("VIEW_ACTION", resource.class.name) do
        Rails.logger.info("VIEW | Time: #{timestamp} | User: #{user} | ID: #{resource.id}")
      end
    end
  end

  private

  def set_current_user
    Current.user = current_user if current_user
  end
end
