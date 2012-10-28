class Admin::CategoriesController <  AdminController

	def index
		@categories = Category.all
		@category = Category.new


	end
	def new
		@category = Category.new

	end
	def create

			@category = Category.new(params[:category])
			if @category.save
				redirect_to admin_categories_path
			else
				render :new
			end
	end

	def edit
		@category = Category.find(params[:id])
	end
	def update
		@category = Category.find(params[:id])
   		if request.method == 'POST'
    		@category = Category.find(params[:id])
    		@category.update_attributes(params[:category])
    		if @category.save
    			redirect_to admin_categories_path
    		else
    			render :edit
    		end
		end
	end

	def destroy
	   		@category = Category.find(params[:id])
			@category.destroy
			redirect_to admin_categories_path
	end
end