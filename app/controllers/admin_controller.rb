class AdminController < ApplicationController
	before_action :redirect_to_root_if_log_in, except: [:log_out]
	before_action :redirect_to_root_if_not_log_in, only: [:log_out]
	def log_in
		
	end

	def log_out
		session[:current_user_id] = nil #session 會跟著瀏覽器
		flash[:notice] = "Logged Out!"
		redirect_to root_path
		return
	end

	def create_session
		user = User.find_by(email: params[:email], password: encrypted(params[:password]))
		if user
			flash[:notice] = "Logged In!"
			session[:current_user_id] = user.id
			redirect_to root_path
			return
		end

		flash[:notice] = "Fail!"
		redirect_to action: :log_in
	end

	def encrypted(password)
		return "aaaaa" + password
	end

	def redirect_to_root_if_log_in
		if current_user
			flash[:notice] = "Already Logged In"
			redirect_to root_path
			return
		end
	end

	def redirect_to_root_if_not_log_in
		if !current_user
			flash[:notice] = "Not Yet Logged In"
			redirect_to root_path
			return
		end
	end
end
