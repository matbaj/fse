class AdminController < ApplicationController
before_filter :check_admin
layout "admin"
	def index

	end
	def order_history
		@orders = Order.all

	end
	def order_detail
		@order = Order.find(params[:id])

	end
	def category
		@categories = Category.all

	end
	def category_add
		if request.method == 'POST'
			@category = Category.new(params[:category])
			@category.save
			redirect_to '/admin/category'
		else
		@category = Category.new
		end

	end

	def category_edit
		@category = Category.find(params[:id])
   		if request.method == 'POST'
    		@category = Category.find(params[:id])
    		@category.update_attributes(params[:category])
    		@category.save
    		redirect_to '/admin/category'
		else
			if params[:id]
				@category = Category.find(params[:id])
			end
		end
	end

	def category_del
		if params[:id]
	   		@category = Category.find(params[:id])
			@category.destroy
			redirect_to '/admin/category'
		end
	end

	def thing
		@things = Thing.all

	end

	def thing_add
		@categories = Category.all
		@thing = Thing.new
		if request.method == 'POST'
			@thing = Thing.new(params[:thing])
			@thing.save
			redirect_to '/admin/thing'
		else
		@thing = Thing.new
		end
	end
	def thing_edit
		@categories = Category.all
		@thing = Thing.find(params[:id])
   		if request.method == 'POST'
    		@thing = Thing.find(params[:id])
    		@thing.update_attributes(params[:thing])
    		@thing.save
    		redirect_to '/admin/thing'
		else
			if params[:id]
				@thing = Thing.find(params[:id])
			end
		end

	end
	def thing_del
		if params[:id]
	   		@thing = Thing.find(params[:id])
			@thing.destroy
			redirect_to '/admin/thing'
		end
	end

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
