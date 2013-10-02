module Api
	module V1
		class PeopleController < ApiController
		
		  # GET /trees/:tree_id/people
		  def index
		  	if current_user.is_admin?
		    	@tree = Tree.includes(:people).find(params[:tree_id])
		    else
		    	@tree = current_user.trees.includes(:people).find(params[:tree_id])
		    end

		    render json: { tree: @tree, people: @tree.people }, status: :ok
		  end

		  # GET /trees/:tree_id/people/:id
		  def show
		  	if current_user.is_admin?
		  		@person = Person.find(params[:id])
		  	else
		    	@person = current_user.trees.find(params[:tree_id]).people.find(params[:id])
				end
		    
		    render json: { person: @person }, status: :ok
		  end

		  # POST /trees/:tree_id/people
		  def create
		  	@tree = current_user.trees.find(params[:tree_id])

		  	relations = {}
		  	modified_people = []

		  	if params[:person][:spouses]
		  		relations[:spouses] = params[:person][:spouses]
		  		params[:person].delete :spouses
		  	end

		  	if params[:person][:children]
		  		relations[:children] = params[:person][:children]
		  		params[:person].delete :children
		  	end

		  	if params[:person][:parents]
		  		relations[:parents] = params[:person][:parents]
		  		params[:person].delete :parents
		  	end

		  	puts params

		  	@person = Person.new(params[:person])
		  	@tree.people << @person
		  	modified_people << @person

		    if @tree.save
		    	relations.each do |k,v|
		    		v.each do |p|
		    			puts "RELATIONS", relations
		    			puts "HERE", k, v, p
		    			relative = @tree.people.find(p)
		    			puts "THERE", relative[k], relative.to_json
		    			#relative.send(k) << @person
		    			#relative.save
		    			@person.send(k) << relative
		    			modified_people << relative
		    		end
		    	end
		    	@person.save

	        render json: { tree: @tree, people: modified_people }, status: :created
	      else
	        render json: @tree.errors, status: :unprocessable_entity
	      end
		  end

		  # PUT /trees/:tree_id/people/:id
		  # only modified person data
		  def update
		    @tree = current_user.trees.find(params[:tree_id])

	      if @tree.nil?
	      	render json: { errors: ["No such tree found"], success: false }, status: :bad_request
	      end

	      @person = @tree.people.find(params[:id])

      	if @person.nil?
      		render json: { errors: ["No such person found"], success: false }, status: :bad_request
      	end

      	params.delete :_id

	      relations = {}
		  	modified_people = []

		  	if params[:person][:spouses]
		  		relations[:spouses] = params[:person][:spouses]
		  		params[:person].delete :spouses
		  	end

		  	if params[:person][:children]
		  		relations[:children] = params[:person][:children]
		  		params[:person].delete :children
		  	end

		  	if params[:person][:parents]
		  		relations[:parents] = params[:person][:parents]
		  		params[:person].delete :parents
		  	end

      	if @person.update_attributes(params[:person])
      		modified_people << @person

      		relations.each do |k,v|
		    		v.each do |p|
		    			puts "RELATIONS", relations
		    			puts "HERE", k, v, p
		    			relative = @tree.people.find(p)
		    			puts "THERE", relative[k], relative.to_json
		    			relative.send(k) << @person
		    			relative.save
		    			modified_people << relative
		    		end
		    	end

        	render json: { person: @person, people: modified_people }, status: :accepted
      	else
        	render json: { errors: @person.errors, success: false }, status: :unprocessable_entity
      	end
		  end

		  # DELETE /trees/:tree_id/people/:id
		  def destroy
		  	tree = current_user.trees.find(params[:tree_id])
		    
		    if tree.nil?
		    	render json: { errors: ["No such tree found"], success: false }, status: :bad_request
		    else
		 			person = tree.people.find(params[:id])

		 			if person.nil?
		 				render json: { errors: ["No such person found"], success: false }, status: :bad_request
		 			else
		 				modified_people = []
		 				modified_people << person.parents
		 				modified_people << person.children
		 				modified_people << person.spouses
		 				modified_people.flatten.map { |person| person._id }
		    		person.destroy
		    		
		    		# respond_with person.destroy
		    		render json: { person: person, people: tree.people.find(modified_people).to_a }, status: :accepted
		    	end
		    end
		  end
		end
	end
end