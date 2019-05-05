class Subcategory < ApplicationRecord
	#migration加了是增加foreign key id，這裡是讓他可以真的連起來，也就是SQL語法可以動
	belongs_to :category 
	has_many :products

	def name_with_category
		"#{category.try(:name)} / #{name}"
	end
end
