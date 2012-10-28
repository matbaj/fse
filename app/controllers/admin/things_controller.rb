class Admin::ThingsController <  AdminController

	def index
		@things = Thing.all

	end
	def new
		@thing = Thing.new

	end
	def create

			@thing = Thing.new(params[:thing])
			if @thing.save
				redirect_to admin_things_path
			else
				render :new
			end
	end

	def edit
		@thing = Thing.find(params[:id])
	end
	def update
		@thing = Thing.find(params[:id])
   		if request.method == 'POST'
    		@thing = Thing.find(params[:id])
    		@thing.update_attributes(params[:thing])
    		if @thing.save
    			redirect_to admin_things_path
    		else
    			render :edit
    		end
		end
	end

	def destroy
	   		@thing = Thing.find(params[:id])
			@thing.destroy
			redirect_to admin_things_path
	end
end