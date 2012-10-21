class ShopController < ApplicationController

	def index
		# render :text => "Hello in my shop!<br> <img src='http://images.wikia.com/adventuretimewithfinnandjake/images/f/f3/Original_Finn.png'>" :D
		
		@categories = Category.all
		@things = Thing.all
	end
	def category
	    @categories = Category.all
	    @category = Category.find(params[:id])
	end
	def category_list
	    @categories = Category.all
	end
	def thing
	    @categories = Category.all
	    @thing = Thing.find(params[:id])

	end

	def order_summary



	end

	def order_payment
		if request.method == 'POST'
			session[:buyer].update_attributes(params[:buyer])
			session[:buyer].save
			@total = 0
			session[:buyer].cart.cart_items.each do |item|
			 @total = @total+item.thing.cost
			end

		else
			redirect_to '/'
		end

	end
	def order_confirm
		@order = Order.new
		@order.buyer = session[:buyer]
		@order.save
		session[:buyer].cart.cart_items.each do  |item| 
			@order_item = OrderItem.new
			@order_item.thing = item.thing.name
			@order_item.cost =item.thing.cost
			@order_item.count =item.count
			@order_item.order = @order
			@order_item.save
		end
		session[:buyer].cart = nil
	end
	def cart_item_add
		if session[:buyer] == nil
			session[:buyer] = Buyer.new
			if user_signed_in?
				session[:buyer].user = current_user
			end
			@new_cart=true
			session[:buyer].cart = Cart.new
			session[:buyer].cart.save
			session[:buyer].save
		end
		if session[:buyer].cart == nil
			@new_cart=true
			session[:buyer].cart = Cart.new
			session[:buyer].cart.save
			session[:buyer].save
		end
		@cartitem = CartItem.new
		@cartitem.thing_id= params[:thing_id]
		#@cartitem.cart = session[:buyer].cart
		@cartitem.count = 1
		@cartitem.save
		session[:buyer].cart.cart_items.append(@cartitem)
		session[:buyer].cart.save
		session[:buyer].save

		respond_to do |format|
	  		format.html { render 'added' }
	  		format.js 
	 	end 

	end
end
