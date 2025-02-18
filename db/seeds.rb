# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Renting.delete_all
Purchase.delete_all
Item.delete_all # clears all exisiting data from tables
User.delete_all

category1 = Category.find_or_create_by(name: "Tool") # creating item categories
category2 = Category.find_or_create_by(name: "Material")

role1 = Role.find_or_create_by(name: "user") # creating roles
role2 = Role.find_or_create_by(name: "admin")

items = Item.create!([ # creates items
  { category: category1, description: "VR Headset", location: "HRBB" },
  { category: category1, description: "VR Headset", location: "HRBB" },
  { category: category1, description: "VR Headset", location: "ILCB" },
  { category: category1, description: "Mouse", location: "HELD" },
  { category: category1, description: "Mouse", location: "HELD" },
  { category: category1, description: "Mouse", location: "ARCC" },
  { category: category1, description: "Headphones", location: "ZACH" },
  { category: category1, description: "Mouse", location: "Zach" },
  { category: category1, description: "HDMI Cable", location: "ZACH" },
  { category: category2, description: "Styrofoam", location: "HRBB" },
  { category: category2, description: "Plutonium", location: "ILCB" },
  { category: category2, description: "Wooden Plank", location: "HELD" },
  { category: category2, description: "Sheet Metal", location: "ZACH" },
  { category: category2, description: "Styrofoam", location: "Zach" },
  { category: category2, description: "Glass", location: "ZACH" },
  { category: category2, description: "Styrofoam", location: "HELD" },
  { category: category2, description: "Styrofoam", location: "HELD" },
  { category: category2, description: "Styrofoam", location: "HELD" }
])

users = User.create!([
  { full_name: "Zach Holman", email: "zach@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Alice Markle", email: "alice@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Brock Purdy", email: "babygoat@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Hugh Jazz", email: "hugh@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "McLovin", email: "mclovin@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Marcel Reed", email: "heisman@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Joe Biden", email: "bigJ@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Deommodore Lenoir", email: "DeMOn@example.com", role_id: role1.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Fred Warner", email: "freddy@example.com", role_id: role2.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Deebo Samuel", email: "19problemz@example.com", role_id: role2.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid },
  { full_name: "Tom Brady", email: "tb12@example.com", role_id: role2.id, password: "password123", avatar_url: "", provider: "Google", uid: SecureRandom.uuid }
])

# users.each do |user|
#   puts "User: #{user.full_name}, Email: #{user.email}"
# end

Purchase.create!([
  { user_id: users.find { |u| u.email == "heisman@example.com" }.id, item_id: items.find { |i| i.description == "VR Headset" && i.location == "HRBB" }.id, purchase_date: "2025-02-11", purchased_quantity: 2 },
  { user_id: users.find { |u| u.email == "alice@example.com" }.id, item_id: items.find { |i| i.description == "Mouse" && i.location == "HELD" }.id, purchase_date: "2025-02-02", purchased_quantity: 2 },
  { user_id: users.find { |u| u.email == "babygoat@example.com" }.id, item_id: items.find { |i| i.description == "Styrofoam" && i.location == "HELD" }.id, purchase_date: "2025-02-09", purchased_quantity: 3 },
  { user_id: users.find { |u| u.email == "tb12@example.com" }.id, item_id: items.find { |i| i.description == "Headphones" && i.location == "ZACH" }.id, purchase_date: "2025-02-06", purchased_quantity: 1 },
  { user_id: users.find { |u| u.email == "mclovin@example.com" }.id, item_id: items.find { |i| i.description == "Wooden Plank" && i.location == "HELD" }.id, purchase_date: "2025-02-07", purchased_quantity: 1 }
])

# Create Renting with user_id and item_id
Renting.create!([
  { user_id: users.find { |u| u.email == "zach@example.com" }.id, item_id: items.find { |i| i.description == "VR Headset" && i.location == "HRBB" }.id, checkout_date: "2025-02-11", return_date: "2025-02-15", quantity: 1 },
  { user_id: users.find { |u| u.email == "19problemz@example.com" }.id, item_id: items.find { |i| i.description == "Mouse" && i.location == "HELD" }.id, checkout_date: "2025-02-10", return_date: "2025-02-12", quantity: 2 },
  { user_id: users.find { |u| u.email == "demon@example.com" }.id, item_id: items.find { |i| i.description == "Wooden Plank" && i.location == "HELD" }.id, checkout_date: "2025-02-09", return_date: "2025-02-14", quantity: 1 },
  { user_id: users.find { |u| u.email == "mclovin@example.com" }.id, item_id: items.find { |i| i.description == "Plutonium" && i.location == "ILCB" }.id, checkout_date: "2025-02-11", return_date: "2025-02-27", quantity: 1 }
])
