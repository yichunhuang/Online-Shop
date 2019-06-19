class Cart < ApplicationRecord
	belongs_to :user
	has_many :cart_items, dependent: :destroy

	enum cart_type: [:buy_now, :buy_next_time] #在資料庫存的會是數字
	validates :cart_type, inclusion: { in: %w(buy_now buy_next_time), message: "%{value} is not a valid cart_type"}

	def amount
		@amount = 0

		cart_items.each do |item|
			@amount += item.quantity * item.product_price
		end

		return @amount
	end
end
