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
        if self.class.name == "Renting"
          DATABASE_LOGGER.info("CREATE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data { Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Checkout Date: #{self.attributes["checkout_date"].to_json} | Rental Date: #{self.attributes["rental_date"].to_json} | Quantity: #{self.attributes["quantity"].to_json} | isReturned: #{self.attributes["is_returned"].to_json} | isSingleUse: #{self.attributes["is_singleuse"].to_json}}")
        end
        if self.class.name == "Item"
          DATABASE_LOGGER.info("CREATE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {Item ID: #{self.attributes["id"].to_json} | Description: #{self.attributes["description"].to_json} | Location: #{self.attributes["location"].to_json} | Category ID: #{self.attributes["category_id"].to_json} | Category: #{Category.find_by(id: self.attributes["category_id"])&.name}")
        end
        if self.class.name == "User"
          DATABASE_LOGGER.info("CREATE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {User ID: #{self.attributes["id"].to_json} | Email: #{self.attributes["email"].to_json} | Full Name: #{self.attributes["full_name"]} | Role ID: #{self.attributes["role_id"].to_json} | Role: #{Role.find_by(id: self.attributes["role_id"])&.name}}")
        end
        if self.class.name == "Purchase"
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
    # previous_state = current_state.deep_dup

    previous_state = {}
    self.attributes.except("created_at", "updated_at").each do |key, value|
      if saved_changes.key?(key)
        previous_state[key] = saved_changes[key][0]  # before value
      else
        previous_state[key] = value  # unchanged
      end
    end

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
        if self.class.name == "Renting"
          DATABASE_LOGGER.info("UPDATE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Item ID: #{previous_state["item_id"].to_json} | Item Name: #{Item.find_by(id: previous_state['item_id'])&.description} | User ID: #{previous_state["user_id"].to_json} | User Email: #{User.find_by(id: previous_state['user_id'])&.email} | Checkout Date: #{previous_state["checkout_date"].to_json} | Rental Date: #{previous_state["rental_date"].to_json} | Quantity: #{previous_state["quantity"].to_json} | isReturned: #{previous_state["is_returned"].to_json} | isSingleUse: #{previous_state["is_singleuse"].to_json}")
          DATABASE_LOGGER.info("AFTER: Item ID: #{current_state["item_id"].to_json} | Item Name: #{Item.find_by(id: current_state['item_id'])&.description} | User ID: #{current_state["user_id"].to_json} | User Email: #{User.find_by(id: current_state['user_id'])&.email} | Checkout Date: #{current_state["checkout_date"].to_json} | Rental Date: #{current_state["rental_date"].to_json} | Quantity: #{current_state["quantity"].to_json} | isReturned: #{current_state["is_returned"].to_json} | isSingleUse: #{current_state["is_singleuse"].to_json}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")
        end
        if self.class.name == "Item"
          DATABASE_LOGGER.info("UPDATE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Data {Item ID: #{previous_state["id"].to_json} | Description: #{previous_state["description"].to_json} | Location: #{previous_state["location"].to_json} | Category ID: #{previous_state["category_id"].to_json} | Category: #{Category.find_by(id: previous_state["category_id"])&.name}")
          DATABASE_LOGGER.info("AFTER: Data {Item ID: #{current_state["id"].to_json} | Description: #{current_state["description"].to_json} | Location: #{current_state["location"].to_json} | Category ID: #{current_state["category_id"].to_json} | Category: #{Category.find_by(id: current_state["category_id"])&.name}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")
        end
        if self.class.name == "User"
          DATABASE_LOGGER.info("UPDATE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Data {User ID: #{previous_state["id"].to_json} | Email: #{previous_state["email"].to_json} | Full Name: #{previous_state["full_name"]} | Role ID: #{previous_state["role_id"].to_json} | Role: #{Role.find_by(id: previous_state["role_id"])&.name}}")
          DATABASE_LOGGER.info("AFTER: Data {User ID: #{current_state["id"].to_json} | Email: #{current_state["email"].to_json} | Full Name: #{current_state["full_name"]} | Role ID: #{current_state["role_id"].to_json} | Role: #{Role.find_by(id: current_state["role_id"])&.name}}")
          DATABASE_LOGGER.info("CHANGES: #{changes.to_json}")
        end
        if self.class.name == "Purchase"
          DATABASE_LOGGER.info("UPDATE PURCHASE | Time: #{timestamp} | User: #{user} | ID: #{self.id}")
          DATABASE_LOGGER.info("BEFORE: Data {Item ID: #{previous_state["item_id"].to_json} | Item Name: #{Item.find_by(id: previous_state['item_id'])&.description} | User ID: #{previous_state["user_id"].to_json} | User Email: #{User.find_by(id: previous_state['user_id'])&.email} | Purchase Date: #{previous_state["purchase_date"].to_json} | Purchase Quantity: #{previous_state["purchased_quantity"].to_json}}")
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
        if self.class.name == "Renting"
          DATABASE_LOGGER.info("DELETE RENTING | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data { Item ID: #{self.attributes["item_id"].to_json} | Item Name: #{Item.find_by(id: self.attributes['item_id'])&.description} | User ID: #{self.attributes["user_id"].to_json} | User Email: #{User.find_by(id: self.attributes['user_id'])&.email} | Checkout Date: #{self.attributes["checkout_date"].to_json} | Rental Date: #{self.attributes["rental_date"].to_json} | Quantity: #{self.attributes["quantity"].to_json} | isReturned: #{self.attributes["is_returned"].to_json} | isSingleUse: #{self.attributes["is_singleuse"].to_json}}")
        end
        if self.class.name == "Item"
          DATABASE_LOGGER.info("DELETE ITEM | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {Item ID: #{self.attributes["id"].to_json} | Description: #{self.attributes["description"].to_json} | Location: #{self.attributes["location"].to_json} | Category ID: #{self.attributes["category_id"].to_json} | Category: #{Category.find_by(id: self.attributes["category_id"])&.name}")
        end
        if self.class.name == "User"
          DATABASE_LOGGER.info("DELETE USER | Time: #{timestamp} | User: #{user} | ID: #{self.id} | Data {User ID: #{self.attributes["id"].to_json} | Email: #{self.attributes["email"].to_json} | Full Name: #{self.attributes["full_name"]} | Role ID: #{self.attributes["role_id"].to_json} | Role: #{Role.find_by(id: self.attributes["role_id"])&.name}}")
        end
        if self.class.name == "Purchase"
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
