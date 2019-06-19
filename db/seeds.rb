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
	address: "Taiwan",
	phone: "0933628656",
	is_admin: true,
	)

unless user.valid?
	puts "user 產生失敗"
	puts user.errors.messages
end

categories = [
	{
		"name": "Classic Collection",
		"description": "something",
		"subcategories": [
			"200g",
			"100g",
			"50g",
		]
	},

	{
		"name": "Seasonal",
		"description": "something",
		"subcategories": [
			"Spring",
			"Easter",
			"Christmas",
		]
	},

	{
		"name": "Gifting",
		"description": "something",
		"subcategories": [
			"Gift Box",
			"Business Gift",
		]
	},

	{
		"name": "Moment",
		"description": "something",
		"subcategories": [
			"Birthday",
			"Wedding",
			"Thank You",
		]
	}
]

categories.each do |c_data|
	category = Category.create(name: c_data[:name], description: c_data[:description])
	unless category.valid?
		puts "category 產生失敗"
		puts category.errors.messages
	end
	c_data[:subcategories].each do |s_data_name|
		subcategory = Subcategory.create(name: s_data_name, category: category)
		unless subcategory.valid?
			puts "subcategory 產生失敗"
			puts subcategory.errors.messages
		end
	end
end

PRODUCT_COUNT = 5

subcategory_count = Subcategory.count

(1..PRODUCT_COUNT).each do |index|
	plus = Random.rand(0..100)

	subcategory_index = Random.rand(0 .. (subcategory_count-1))
	subcategory = Subcategory.all[subcategory_index]

	product = {
		name: "巧克力片",
		description: "內含堅果",
		price: 1000 + plus,
		# image_url: "https://images.pexels.com/photos/42065/background-brown-calorie-candy-42065.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
		subcategory: subcategory
	}

	product = Product.create(product)

	unless product.valid?
		puts "product 產生失敗"
		puts product.errors.messages
	end
end


