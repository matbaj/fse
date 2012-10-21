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
	
end
