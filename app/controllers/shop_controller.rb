class ShopController < ApplicationController
	before_filter :set_buyer
	def set_buyer
		if session[:buyer_id] != nil
	  		@buyer = Buyer.find(session[:buyer_id])
		end
	end

	
	def index
		# render :text => "Hello in my shop!<br> <img src='http://images.wikia.com/adventuretimewithfinnandjake/images/f/f3/Original_Finn.png'>" :D
		
		@categories = Category.all
		#@things = Thing.all
	
	end



	def order_summary



	end

	def order_payment
		if request.method == 'POST'
			@buyer.update_attributes(params[:buyer])
			@buyer.save
			@total = 0
			@buyer.cart.cart_items.each do |item|
			 @total = @total+item.thing.cost
			end

		else
			redirect_to '/'
		end

	end
	def order_confirm
		@order = Order.new
		@order.buyer = @buyer
		@order.save
		@buyer.cart.cart_items.each do  |item| 
			@order_item = OrderItem.new
			@order_item.thing = item.thing.name
			@order_item.cost =item.thing.cost
			@order_item.count =item.count
			@order_item.order = @order
			@order_item.save
		end
		@buyer.cart = nil
		@buyer.save
	end
	def cart_item_add
		if session[:buyer_id] == nil
			@buyer = Buyer.new
			if user_signed_in?
				@buyer.user = current_user
			end
			@new_cart=true
			@buyer.cart = Cart.new
			@buyer.cart.save
			@buyer.save
			session[:buyer_id] = @buyer.id
		end
		if @buyer.cart == nil
			@new_cart=true
			@buyer.cart = Cart.new
			@buyer.cart.save
			@buyer.save
		end
		@cartitem = CartItem.new
		@cartitem.thing_id= params[:thing_id]
		@cartitem.cart = @buyer.cart
		@cartitem.count = 1
		@cartitem.save

		respond_to do |format|
	  		format.html { render 'added' }
	  		format.js 
	 	end 

	end
end
