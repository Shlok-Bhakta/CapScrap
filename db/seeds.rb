# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'


# Delete all existing data
Renting.delete_all
Purchase.delete_all
Item.delete_all
User.delete_all
Category.delete_all
Role.delete_all

# reset all sequences
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('items')
ActiveRecord::Base.connection.reset_pk_sequence!('categories')
ActiveRecord::Base.connection.reset_pk_sequence!('roles')
ActiveRecord::Base.connection.reset_pk_sequence!('purchases')
ActiveRecord::Base.connection.reset_pk_sequence!('rentings')



# These are the categories that the customer wanted.
tools_category = Category.find_or_create_by(name: "Tool") # creating item categories
material_category = Category.find_or_create_by(name: "Material")
equipment_category = Category.find_or_create_by(name: "Equipment")

# creating roles
student_role = Role.find_or_create_by(name: "Student")
ta_role = Role.find_or_create_by(name: "Teaching Assistant")
prof_role = Role.find_or_create_by(name: "Professor")


# realistically we only want one of each in the system. the quantity is calculated on the fly from the in and out values.
Item.create!(100.times.map do
  {
    category: rand(1..3) == 1 ? equipment_category : rand(1..3) == 1 ? tools_category : material_category,
    description: Faker::Commerce.product_name,
    location: rand(1..3) == 1 ? "HRBB" : rand(1..3) == 1 ? "HELD" : rand(1..3) == 1 ? "ZACH" : "ILCB",
    comments: rand(0..1) == 1 ? nil : Faker::Lorem.paragraph
  }
end)

# items = Item.create!([ # creates items
#   { category: equipment_category, description: "VR Headset", location: "HRBB" },
#   { category: tools_category, description: "Mouse", location: "HELD" },
#   { category: tools_category, description: "Headphones", location: "ZACH" },
#   { category: tools_category, description: "HDMI Cable", location: "ZACH" },
#   { category: material_category, description: "Styrofoam", location: "HRBB" },
#   { category: material_category, description: "Plutonium", location: "ILCB" },
#   { category: material_category, description: "Wooden Plank", location: "HELD" },
#   { category: material_category, description: "Sheet Metal", location: "ZACH" },
#   { category: material_category, description: "Glass", location: "ZACH" }

#   ])



# use faker to generate fake data
User.create!(100.times.map do
  {
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    role_id: rand(1..3),
    password: Faker::Internet.password,
    avatar_url: Faker::Avatar.image,
    provider: "Google",
    uid: SecureRandom.uuid
  }
end)


# users.each do |user|
#   puts "User: #{user.full_name}, Email: #{user.email}"
# end


# create fake purchases
Purchase.create!(100.times.map do
  {
    user_id: User.all.sample.id,
    item_id: Item.all.sample.id,
    purchase_date: Faker::Date.between(from: Date.today - 10, to: Date.today),
    purchased_quantity: rand(1..10),
    comments: rand(0..1) == 1 ? nil : Faker::Lorem.paragraph
  }
end)

Renting.create!(100.times.map do
  {
    user_id: User.all.sample.id,
    item_id: Item.all.sample.id,
    checkout_date: Faker::Date.between(from: Date.today - 10, to: Date.today),
    return_date: Faker::Date.between(from: Date.today+1, to: Date.today+10),
    is_returned: rand(0..1) == 1,
    is_singleuse: rand(0..1) == 1,
    quantity: rand(1..10),
    comments: rand(0..1) == 1 ? nil : Faker::Lorem.paragraph
  }
end)
# Purchase.create!([
#   { user_id: users.find { |u| u.email == "heisman@example.com" }.id, item_id: items.find { |i| i.description == "VR Headset" }.id, purchase_date: "2025-02-11", purchased_quantity: 2 },
#   { user_id: users.find { |u| u.email == "alice@example.com" }.id, item_id: items.find { |i| i.description == "Mouse" }.id, purchase_date: "2025-02-02", purchased_quantity: 2 },
#   { user_id: users.find { |u| u.email == "babygoat@example.com" }.id, item_id: items.find { |i| i.description == "Styrofoam" }.id, purchase_date: "2025-02-09", purchased_quantity: 3 },
#   { user_id: users.find { |u| u.email == "tb12@example.com" }.id, item_id: items.find { |i| i.description == "Headphones" }.id, purchase_date: "2025-02-06", purchased_quantity: 1 },
#   { user_id: users.find { |u| u.email == "mclovin@example.com" }.id, item_id: items.find { |i| i.description == "Wooden Plank" }.id, purchase_date: "2025-02-07", purchased_quantity: 1 },
#   { user_id: users.find { |u| u.email == "mclovin@example.com" }.id, item_id: items.find { |i| i.description == "Plutonium" }.id, purchase_date: "2025-02-07", purchased_quantity: 20 }
# ])

# # Create Renting with user_id and item_id
# Renting.create!([
#   { user_id: users.find { |u| u.email == "zach@example.com" }.id, item_id: items.find { |i| i.description == "VR Headset" }.id, checkout_date: "2025-02-11", return_date: "2025-02-15", is_returned: true, quantity: 1 },
#   { user_id: users.find { |u| u.email == "19problemz@example.com" }.id, item_id: items.find { |i| i.description == "Mouse" }.id, checkout_date: "2025-02-10", return_date: "2025-02-12", quantity: 2 },
#   { user_id: users.find { |u| u.email == "demon@example.com" }.id, item_id: items.find { |i| i.description == "Wooden Plank" }.id, checkout_date: "2025-02-09", return_date: "2025-02-14", is_returned: false, is_singleuse: true, quantity: 1 },
#   { user_id: users.find { |u| u.email == "mclovin@example.com" }.id, item_id: items.find { |i| i.description == "Plutonium" }.id, checkout_date: "2025-02-11", return_date: "2025-02-27", is_returned: false, is_singleuse: true, quantity: 5 }
# ])
