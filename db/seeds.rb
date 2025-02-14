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

users = User.create!([ # adds users to the database
  { first_name: "Zach", last_name: "Holman", email: "zach@example.com", role: role1 },
  { first_name: "Alice", last_name: "Markle", email: "alice@example.com", role: role1 },
  { first_name: "Brock", last_name: "Purdy", email: "babygoat@example.com", role: role1 },
  { first_name: "Hugh", last_name: "Jazz", email: "hugh@example.com", role: role1 },
  { first_name: "McLovin", last_name: ".", email: "mclovin@example.com", role: role1 },
  { first_name: "Marcel", last_name: "Reed", email: "heisman@example.com", role: role1 },
  { first_name: "Joe", last_name: "Biden", email: "bigJ@example.com", role: role1 },
  { first_name: "Deommodore", last_name: "Lenoir", email: "DeMOn@example.com", role: role1 },
  { first_name: "Fred", last_name: "Warner", email: "freddy@example.com", role: role2 },
  { first_name: "Deebo", last_name: "Samuel", email: "19problemz@example.com", role: role2 },
  { first_name: "Tom", last_name: "Brady", email: "tb12@example.com", role: role2 }
])

Purchase.create!([ # adds to purchase table
  { user: users.find { |u| u.email == "heisman@example.com" }, item: items.find { |i| i.description == "VR Headset" && i.location == "HRBB" }, purchase_date: "2025-02-11", purchased_quantity: 2 },
  { user: users.find { |u| u.email == "alice@example.com" }, item: items.find { |i| i.description == "Mouse" && i.location == "HELD" }, purchase_date: "2025-02-10", purchased_quantity: 2 },
  { user: users.find { |u| u.email == "babygoat@example.com" }, item: items.find { |i| i.description == "Styrofoam" && i.location == "HELD" }, purchase_date: "2025-02-09", purchased_quantity: 3 },
  { user: users.find { |u| u.email == "tb12@example.com" }, item: items.find { |i| i.description == "Headphones" && i.location == "ZACH" }, purchase_date: "2025-02-08", purchased_quantity: 1 },
  { user: users.find { |u| u.email == "mclovin@example.com" }, item: items.find { |i| i.description == "Wooden Plank" && i.location == "HELD" }, purchase_date: "2025-02-07", purchased_quantity: 1 }
])

Renting.create!([ # adds to renting table
  { user: users.find { |u| u.email == "zach@example.com" }, item: items.find { |i| i.description == "VR Headset" && i.location == "HRBB" }, checkout_date: "2025-02-11", return_date: "2025-02-15", quantity: 1 },
  { user: users.find { |u| u.email == "19problemz@example.com" }, item: items.find { |i| i.description == "Mouse" && i.location == "HELD" }, checkout_date: "2025-02-10", return_date: "2025-02-12", quantity: 2 },
  { user: users.find { |u| u.email == "DeMOn@example.com" }, item: items.find { |i| i.description == "Wooden Plank" && i.location == "HELD" }, checkout_date: "2025-02-09", return_date: "2025-02-14", quantity: 1 },
  { user: users.find { |u| u.email == "mclovin@example.com" }, item: items.find { |i| i.description == "Plutonium" && i.location == "ILCB" }, checkout_date: "2025-02-11", return_date: "2025-02-27", quantity: 1 }
])
