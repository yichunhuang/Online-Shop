class OrdersController < ApplicationController
	before_action :redirect_to_root_if_not_log_in
	before_action :get_order, only: [:show, :update, :destroy]
	before_action :verify_admin, only: [:admin]

	def index
		# Show all orders of an user
		@orders = current_user.orders
	end

	def show
		# Show detail of an order
		@order_items = @order.order_items
	end

	def create

		if current_user.buy_now_cart_items.count == 0
			flash[:notice] = "沒有商品"
			redirect_to cart_items_path
			return
		end

		# Change order status to not-paid
		# 不會有new頁面，因為new就是確定購買那個頁面
		# 建立一個訂單，狀態是未付款

		# Create order
		@order = Order.not_paid.create(
			 # 不用try current_user因為before_action 有先確認過一定有
			user: current_user,
			user_name: current_user.name, 
			user_address: current_user.address,
			user_phone: current_user.phone
			)

		current_user.buy_now_cart_items.each do |cart_item|
			begin
			# Create order_item
			# !是invalid也會丟exception
			order_item = OrderItem.create!(
				order: @order,
				product: cart_item.product,
				quantity: cart_item.quantity,
				price: cart_item.product_price
				)
			rescue
			# 避免OrderItem有問題，只有Order沒有OrderItem的錯誤情況
				@order.order_items.destroy_all
				@order.destroy
				flash[:notice] = "訂單建立失敗"
				redirect_to root_path
				return
			end
		end

		# Destroy cart_item
		current_user.buy_now_cart_items.destroy_all

		flash[:notice] = "建立訂單成功"
		redirect_to payments_path(order_id: @order.id)
		return
	end

	def update
		# Change order status to paid
		# 更新一個訂單，狀態改成已付款
		# 這邊是給顧客看的，如果是超級使用者可以在另一個admin controller的地方做edit & update

		if params[:payment_method] == "credit card"	
			@order.paid!	
			flash[:notice] = "訂單付款成功"
			redirect_to root_path
			return
		else #超商付款
			flash[:notice] = "訂單待付款"
			redirect_to root_path
			return
		end
		
	end

	def destroy
		# Change order status to cancelled
		# 訂單不會被刪除，而是更新訂單狀態為取消

	end

	def admin
		@orders = Order.all
	end

	private

	def redirect_to_root_if_not_log_in
		if !current_user
			flash[:notice] = "You have not log in yet."
			redirect_to root_path
			return
		end
	end

	def get_order
		@order = Order.find_by_id(params[:id])
		if !@order
			flash[:notice] = "沒有這個訂單"
			redirect_to root_path
			return
		end

		unless (current_user == @order.user) || current_user.is_admin
			flash[:notice] = "沒有這個訂單(這不是你的訂單)"
			redirect_to root_path
			return
		end
	end

	def verify_admin
		unless current_user.is_admin? 
			flash[:notice] = "您沒有權限"
			redirect_to root_path
			return
		end
	end
end
