Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/pbadmin', as: 'rails_admin'
  root "products#index"

  resources :products

  resources :categories, param: :category_id, except: [:index] do #except, only可以關掉預設但不需要用到的url
  	collection do
  	end

  	member do 
  		get :products

  		resources :subcategories, param: :subcategory_id, only: [] do
  			member do
  				get :products
  			end
  		end
  	end
  	# collection do
    # 	get :products 做出來會是 categories/products，index+url的概念
    # end

    # member do
    # 	get :products 做出來會是 categories/:id/products，show+url的概念
    # end
  end

  get "admin/log_in", to: "admin#log_in"
  post "admin/create_session", to: "admin#create_session"
  get "admin/log_out", to: "admin#log_out"
end