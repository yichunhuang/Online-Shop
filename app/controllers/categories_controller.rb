class CategoriesController < ProductsController
	before_action :get_category, only: [:products]
	before_action :get_products, only: [:products]
	before_action :create_pagination, only: [:products]
	LIMITED_PRODUCTS_NUMBER = 20

	def products
		#有繼承products會先做prepare index，然後再做get products時
		#發現已經被overwrite，所以會用這裡的定義
	end

	private
	def get_category
		@category = Category.find_by_id(params[:category_id])
	end

	def get_products
		@products = @category.products
	end
end
