# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Item.delete_all #clears all exisiting data from tables



category1 = Category.find_or_create_by(name: "Tool") #creating item categories
category2 = Category.find_or_create_by(name: "Material")

role1 = Role.find_or_create_by(name: "user") #creating roles
role2 = Role.find_or_create_by(name: "admin")

Item.create!([ #creates items
  { category: category1, description: "VR Headset", location: "HRBB" },
  { category: category1, description: "VR Headset", location: "ILCB" },
  { category: category1, description: "Mouse", location: "HELD" },
  { category: category1, description: "Headphones", location: "ZACH" },
  { category: category1, description: "Mouse", location: "Zach" },
  { category: category1, description: "HDMI Cable", location: "ZACH" },
  { category: category2, description: "Styrofoam", location: "HRBB" },
  { category: category2, description: "Plutonium", location: "ILCB" },
  { category: category2, description: "Wooden Plank", location: "HELD" },
  { category: category2, description: "Sheet Metal", location: "ZACH" },
  { category: category2, description: "Styrofoam", location: "Zach" },
  { category: category2, description: "Glass", location: "ZACH" },
])



