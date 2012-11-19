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
	
end
