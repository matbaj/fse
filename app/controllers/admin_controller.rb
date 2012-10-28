class AdminController < ApplicationController
before_filter :check_admin
layout "admin"


	private

	def check_admin
		if user_signed_in?
			if current_user.admin

			else
				render "not_admin", :layout => false
			end
		else
			redirect_to "/users/sign_in"
		end

	end
end
