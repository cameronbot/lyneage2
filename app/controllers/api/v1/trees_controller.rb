module Api
	module V1
		class TreesController < ApiController

		  # GET /trees
		  def index
		  	if current_user.is_admin?
		    	@trees = Tree.all
		    else
		    	@trees = current_user.trees #Tree.where(user_id: current_user._id)
		    end

		    render json: { trees: @trees }, status: :ok
		  end

		  # GET /trees/:id
		  def show
		  	if current_user.is_admin?
		  		@tree = Tree.find(params[:id])
		  	else
		    	@tree = current_user.trees.find(params[:id])
				end
		    
		    render json: { tree: @tree, people: @tree.people }, status: :ok
		  end

		  # POST /trees
		  def create
		  	@tree = current_user.trees.build(params[:tree])

		    if @tree.save
	        render json: { tree: @tree }, status: :created
	      else
	        render json: @tree.errors, status: :unprocessable_entity
	      end
		  end

		  # PUT /trees/:id
		  def update
		    @tree = current_user.trees.find(params[:id])

	      unless @tree.nil?
	      	if @tree.update_attributes(params[:tree])
	        	render json: { tree: @tree }, status: :accepted
	      	else
	        	render json: { errors: @tree.errors, success: false }, status: :unprocessable_entity
	      	end
	      else
	      	render json: { errors: ["No such tree found"], success: false }, status: :bad_request
	      end
		  end

		  # DELETE /trees/:id
		  def destroy
		  	tree = current_user.trees.find(params[:id])
		    
		    if tree.nil?
		    	render json: { errors: ["No such tree found"], success: false }, status: :bad_request
		    else
		    	respond_with tree.destroy
		    end
		  end
		end
	end
end