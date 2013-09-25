module Api
	module V1
		class TreesController < ApiController
			#before_filter :authenticate_user!
		
		  # GET /trees
		  # GET /trees.json
		  def index
		  	if current_user.is_admin?
		    	@trees = Tree.all
		    else
		    	@trees = current_user.trees #Tree.where(user_id: current_user._id)
		    end

		    render json: { trees: @trees }, status: :ok
		  end

		  # GET /trees/:id
		  # GET /trees/:id.json
		  def show
		  	if current_user.is_admin?
		  		@tree = Tree.find(params[:id])
		  	else
		    	@tree = current_user.trees.find(params[:id])
				end
		    
		    render json: { tree: @tree }, status: :ok
		  end

		  # POST /trees
		  # POST /trees.json
		  def create
		  	@tree = current_user.trees.build(params[:tree])

		    if @tree.save
	        render json: { tree: @tree }, status: :created
	      else
	        render json: @tree.errors, status: :unprocessable_entity
	      end
		  end

		  # PUT /trees/:id
		  # PUT /trees/:id.json
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

		  # DELETE /pages/:id
		  # DELETE /pages/:id.json
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