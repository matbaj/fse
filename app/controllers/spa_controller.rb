class SpaController < ApplicationController
layout 'spa'
	def index


	end

	def things
		@q = Thing.search(params[:q])
		@things = @q.result(:distinct => true)
		@categories = Category.all
		render :json => @things
	end
	def categories
		@categories = Category.all
		render :json => @categories
	end

	def send_order
		@buyer = Buyer.new
		@buyer.first_name = params[:first]
		@buyer.last_name = params[:last]
		@buyer.save
		@order = Order.new
		@order.buyer = @buyer
		@order.save
		params[:t].each do |i| 
			thing = Thing.find(i[1][0].to_i)
			@order_item = OrderItem.new
			@order_item.thing = thing.name
			@order_item.cost = thing.cost
			@order_item.count =i[1][1].to_i	
			@order_item.order = @order
			@order_item.save
		end

		render :text => "OK"
	end
	
end
