class CartItemsController < ApplicationController

	before_action :redirect_to_root_if_not_log_in
	before_action :get_cart, except: [:index, :update, :destroy]
	before_action :get_cart_item, only: [:update, :destroy]

	def index
		@buy_now_items = current_user.buy_now_cart_items
		@buy_next_time_items = current_user.buy_next_time_cart_items
		@amount = current_user.buy_now_cart.amount
	end

	def create
		product = Product.find_by_id(params[:product_id])
		if !product
			flash[:notice] = "沒有這個商品"
			redirect_to root_path
			return
		end

		cart_item = CartItem.create(product: product, quantity: params[:quantity], cart: @cart)
		if cart_item.valid?
			if @cart.buy_now?
				flash[:notice] = "加入購物車成功"
			elsif @cart.buy_next_time?
			 	flash[:notice] = "加入下次購買成功"
			end
		else
			flash[:notice] = cart_item.errors.messages
		end

		redirect_to product_path(product)
	end

	def update

		# update可以根據回傳的true/false做判斷
		# 但create destroy不行
		if @cart_item.update(cart_item_permit)
			flash[:notice] = "更新成功"
		else
			flash[:notice] = "更新失敗"
		end

		redirect_to action: :index
	end

	def destroy
		@cart_item.destroy
		# destroy create不管成功與否 都還是會有值
		# 所以destroy要用destroyed? create要用valid?
		if @cart_item.destroyed?
			flash[:notice] = "刪除成功"
		else
			flash[:notice] = "刪除失敗"
		end
		redirect_to action: :index
	end

	private

	def redirect_to_root_if_not_log_in
		if !current_user
			flash[:notice] = "Not Yet Logged In"
			redirect_to root_path
			return
		end
	end

	def get_cart
		@cart = current_user.carts.find_by(cart_type: params[:cart_type])

		if !@cart
			flash[:notice] = "Do not find cart"
			redirect_to action: :index
			return
		end	
	end


	def get_cart_item
		
		@cart_item = CartItem.find_by_id(params[:id])

		if !@cart_item || @cart_item.user != current_user
			flash[:notice] = "Do not find cart item"
			redirect_to action: :index
			return
		end
	end

	def cart_item_permit
		params.require(:cart_item).permit([:quantity])
	end
end
