# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(
	name: "admin",
	email: "b03704074@ntu.edu.tw",
	password: "123456",
	is_admin: true,
	)
categories = [
	{
		"name": "Classic Collection",
		"subcategories": [
			"200g",
			"100g",
			"50g",
		]
	},

	{
		"name": "Seasonal",
		"subcategories": [
			"Spring",
			"Easter",
			"Christmas",
		]
	},

	{
		"name": "Gifting",
		"subcategories": [
			"Gift Box",
			"Business Gift",
		]
	},

	{
		"name": "Moment",
		"subcategories": [
			"Birthday",
			"Wedding",
			"Thank You",
		]
	}
]

categories.each do |c_data|
	category = Category.create(name: c_data[:name])
	c_data[:subcategories].each do |s_data_name|
		subcategory = Subcategory.create(name: s_data_name, category: category)
	end
end


subcategory = Subcategory.all[0]
PRODUCT_COUNT = 100

(1..PRODUCT_COUNT).each do |index|
product = {
name: "巧克力片",
description: "內含堅果",
image_url: "https://images.pexels.com/photos/42065/background-brown-calorie-candy-42065.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
subcategory: subcategory
}

Product.create(product)
end


