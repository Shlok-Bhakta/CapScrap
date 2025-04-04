# # app/models/concerns/loggable.rb
# module Loggable
#   extend ActiveSupport::Concern

#   included do
#     after_create :log_create
#     after_update :log_update
#     before_destroy :log_destroy
#   end

#   private

#   def log_create
#     user = current_user_identifier
#     log_action("CREATE", user)
#   end

#   def log_update
#     user = current_user_identifier
#     log_action("UPDATE", user)
#   end

#   def log_destroy
#     user = current_user_identifier
#     log_action("DESTROY", user)
#   end

#   def log_action(action_type, user)
#     attributes_info = self.attributes.except("created_at", "updated_at").to_json
  
#     # Log to both the main Rails logger and your custom logger
#     Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
#       Rails.logger.info("#{action_type} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
#     end
    
#     DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
#       DATABASE_LOGGER.info("#{action_type} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
#     end
#   end
#   #   attributes_info = self.attributes.except("created_at", "updated_at").to_json
#   #   Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
#   #     Rails.logger.info("#{action_type} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
#   #   end
#   # end

#   def current_user_identifier
#     # In a Rails app, this would typically come from something like Current.user
#     # This is a placeholder - you'll need to adapt this to your user tracking method
#     if defined?(Current) && Current.respond_to?(:user) && Current.user
#       "#{Current.user.id} (#{Current.user.email})"
#     elsif Thread.current[:current_user]
#       user = Thread.current[:current_user]
#       "#{user.id} (#{user.email})"
#     else
#       "Unknown User"
#     end
#   end
# end

# # app/models/concerns/loggable.rb
# module Loggable
#   extend ActiveSupport::Concern

#   included do
#     after_create :log_create
#     before_update :store_previous_state
#     after_update :log_update
#     before_destroy :log_destroy
#   end

#   private

#   def store_previous_state
#     @previous_attributes = self.attributes.deep_dup
#   end

#   def log_create
#     user = current_user_identifier
#     timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
    
#     if defined?(DATABASE_LOGGER)
#       DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
#         DATABASE_LOGGER.info("CREATE | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
#       end
#     else
#       Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
#         Rails.logger.info("CREATE | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
#       end
#     end
#   end

#   def log_update
#     user = current_user_identifier
#     timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
    
#     # Get the current attributes (after the update)
#     current_attributes = self.attributes.except("created_at", "updated_at")
    
#     # Get the original attributes (before the update)
#     previous_attributes = @previous_attributes.except("created_at", "updated_at") if @previous_attributes
    
#     # Create a diff showing what changed
#     changes = {}
#     current_attributes.each do |key, value|
#       if previous_attributes && previous_attributes[key] != value
#         changes[key] = {
#           before: previous_attributes[key],
#           after: value
#         }
#       end
#     end
    
#     if defined?(DATABASE_LOGGER)
#       DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
#         DATABASE_LOGGER.info("UPDATE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
#         DATABASE_LOGGER.info("BEFORE: #{previous_attributes.to_json}")
#         DATABASE_LOGGER.info("AFTER: #{current_attributes.to_json}")
#         DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")
#       end
#     else
#       Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
#         Rails.logger.info("UPDATE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
#         Rails.logger.info("BEFORE: #{previous_attributes.to_json}")
#         Rails.logger.info("AFTER: #{current_attributes.to_json}")
#         Rails.logger.info("CHANGES: #{changes.to_json}")
#       end
#     end
#   end

#   def log_destroy
#     user = current_user_identifier
#     timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
#     attributes_info = self.attributes.except("created_at", "updated_at").to_json
    
#     if defined?(DATABASE_LOGGER)
#       DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
#         DATABASE_LOGGER.info("DESTROY | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
#       end
#     else
#       Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
#         Rails.logger.info("DESTROY | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
#       end
#     end
#   end

#   def current_user_identifier
#     # In a Rails app, this would typically come from something like Current.user
#     # This is a placeholder - adapt to your user tracking method
#     if defined?(Current) && Current.respond_to?(:user) && Current.user
#       "#{Current.user.id} (#{Current.user.email})"
#     elsif Thread.current[:current_user]
#       user = Thread.current[:current_user]
#       "#{user.id} (#{user.email})"
#     else
#       "Unknown User"
#     end
#   end
# end

# app/models/concerns/loggable.rb
module Loggable
  extend ActiveSupport::Concern

  included do
    after_create :log_create
    before_update :store_previous_state
    after_update :log_update
    before_destroy :log_destroy
  end

  private

  def store_previous_state
    # Store the entire record's state before update
    @previous_state = self.attributes.except("created_at", "updated_at").deep_dup
  end

  def log_create
    user = current_user_identifier
    timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
    
    if defined?(DATABASE_LOGGER)
      DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
        if(self.class.name == "Renting")
          DATABASE_LOGGER.info("CREATE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data { Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Checkout Date: #{self.attributes["checkout_date"].to_json} | Rental Date: #{self.attributes["rental_date"].to_json} | Quantity: #{self.attributes["quantity"].to_json} | isReturned: #{self.attributes["is_returned"].to_json} | isSingleUse: #{self.attributes["is_singleuse"].to_json}}")
        end
        if(self.class.name == "Item")
          DATABASE_LOGGER.info("CREATE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
        end
        if(self.class.name == "User")
          DATABASE_LOGGER.info("CREATE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
        end
        if(self.class.name == "Purchase")
          DATABASE_LOGGER.info("CREATE PURCHASE | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Purchase Date: #{self.attributes["purchase_date"].to_json} | Purchase Quantity: #{self.attributes["purchased_quantity"].to_json}}")
        end
      end
    else
      Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
        Rails.logger.info("CREATE | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
      end
    end
  end

  def log_update
    user = current_user_identifier
    timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
    
    # Get the current state
    current_state = self.attributes.except("created_at", "updated_at")
    
    # Get detailed changes using Rails' saved_changes
    changes = {}
    saved_changes.except("created_at", "updated_at").each do |key, value|
      changes[key] = {
        before: value[0],
        after: value[1]
      }
    end
    
    if defined?(DATABASE_LOGGER)
      DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
        DATABASE_LOGGER.info("UPDATE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
        if(self.class.name == "Renting")
          DATABASE_LOGGER.info("UPDATE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Item ID: #{@previous_state["item_id"].to_json} | Item Name: #{Item.find_by(id: @previous_state['item_id'])&.description} | User ID: #{@previous_state["user_id"].to_json} | User Email: #{User.find_by(id: @previous_state['user_id'])&.email} | Checkout Date: #{@previous_state["checkout_date"].to_json} | Rental Date: #{@previous_state["rental_date"].to_json} | Quantity: #{@previous_state["quantity"].to_json} | isReturned: #{@previous_state["is_returned"].to_json} | isSingleUse: #{@previous_state["is_singleuse"].to_json}")
          DATABASE_LOGGER.info("AFTER: Item ID: #{current_state["item_id"].to_json} | Item Name: #{Item.find_by(id: current_state['item_id'])&.description} | User ID: #{current_state["user_id"].to_json} | User Email: #{User.find_by(id: current_state['user_id'])&.email} | Checkout Date: #{current_state["checkout_date"].to_json} | Rental Date: #{current_state["rental_date"].to_json} | Quantity: #{current_state["quantity"].to_json} | isReturned: #{current_state["is_returned"].to_json} | isSingleUse: #{current_state["is_singleuse"].to_json}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")  
        end
        if(self.class.name == "Item")
          DATABASE_LOGGER.info("UPDATE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")  
        end
        if(self.class.name == "User")
          DATABASE_LOGGER.info("UPDATE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")  
        end
        if(self.class.name == "Purchase")
          DATABASE_LOGGER.info("UPDATE PURCHASE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Data {Item ID: #{@previous_state["item_id"].to_json} | Item Name: #{Item.find_by(id: @previous_state['item_id'])&.description} | User ID: #{@previous_state["user_id"].to_json} | User Email: #{User.find_by(id: @previous_state['user_id'])&.email} | Purchase Date: #{@previous_state["purchase_date"].to_json} | Purchase Quantity: #{@previous_state["purchased_quantity"].to_json}}")
          DATABASE_LOGGER.info("AFTER: Data {Item ID: #{current_state["item_id"].to_json} | Item Name: #{Item.find_by(id: current_state['item_id'])&.description} | User ID: #{current_state["user_id"].to_json} | User Email: #{User.find_by(id: current_state['user_id'])&.email} | Purchase Date: #{current_state["purchase_date"].to_json} | Purchase Quantity: #{current_state["purchased_quantity"].to_json}}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")  
        end
      end
    else
      Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
        Rails.logger.info("UPDATE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
        Rails.logger.info("BEFORE: #{@previous_state.to_json}")
        DATABASE_LOGGER.info("AFTER: #{current_state.to_json}")
        DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")
      end
    end
  end

  def log_destroy
    user = current_user_identifier
    timestamp = Time.current.strftime("%Y-%m-%d %H:%M:%S")
    attributes_info = self.attributes.except("created_at", "updated_at").to_json
    
    if defined?(DATABASE_LOGGER)
      DATABASE_LOGGER.tagged("DATABASE_ACTION", self.class.name) do
        if(self.class.name == "Renting")
          DATABASE_LOGGER.info("DELETE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data { Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Checkout Date: #{self.attributes["checkout_date"].to_json} | Rental Date: #{self.attributes["rental_date"].to_json} | Quantity: #{self.attributes["quantity"].to_json} | isReturned: #{self.attributes["is_returned"].to_json} | isSingleUse: #{self.attributes["is_singleuse"].to_json}}")
        end
        if(self.class.name == "Item")
          DATABASE_LOGGER.info("DELETE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
        end
        if(self.class.name == "User")
          DATABASE_LOGGER.info("DELETE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{self.attributes.except("created_at", "updated_at").to_json}")
        end
        if(self.class.name == "Purchase")
          DATABASE_LOGGER.info("DELETE PURCHASE | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Purchase Date: #{self.attributes["purchase_date"].to_json} | Purchase Quantity: #{self.attributes["purchased_quantity"].to_json}}")
        end
      end
    else
      Rails.logger.tagged("DATABASE_ACTION", self.class.name) do
      Rails.logger.info("DESTROY | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data: #{attributes_info}")
      end
    end
  end

 
  def current_user_identifier
    if Current.user
      "#{Current.user.id} (#{Current.user.email})"
    else
      "Unknown User"
    end
  end
end