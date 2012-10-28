class ThingsController < ApplicationController

	def show
	    @categories = Category.all
	    @thing = Thing.find(params[:id])

	end

end