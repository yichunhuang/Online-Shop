class Product < ApplicationRecord
	belongs_to :subcategory
	has_many :cart_items
	has_many :order_items
	has_one :category, through: :subcategory

	validates :name, :description, presence: true
	validates :price , numericality: {only_integer: true, 
										greater_than_or_equal_to: 0}			
	# carrierwave gem用法
	mount_uploader :image_url, ImageUploader
end
