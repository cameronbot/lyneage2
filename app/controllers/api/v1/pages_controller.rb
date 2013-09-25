module Api
	module V1
		class PagesController < ApplicationController
			before_filter :authenticate_user!
			
			respond_to :json
		  # GET /pages
		  # GET /pages.json
		  def index
		    @pages = Page.all

		    respond_with @pages
		  end

		  # GET /pages/1
		  # GET /pages/1.json
		  def show
		    @page = Page.find(params[:id])

		    respond_with @page
		  end

		  # POST /pages
		  # POST /pages.json
		  def create
		    @page = Page.new(params[:page])

		    respond_to do |format|
		      if @page.save
		        format.html { redirect_to @page, notice: 'Page was successfully created.' }
		        format.json { render json: @page, status: :created, location: @page }
		      else
		        format.html { render action: "new" }
		        format.json { render json: @page.errors, status: :unprocessable_entity }
		      end
		    end
		  end

		  # PUT /pages/1
		  # PUT /pages/1.json
		  def update
		    @page = Page.find(params[:id])

		    respond_to do |format|
		      if @page.update_attributes(params[:page])
		        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
		        format.json { head :no_content }
		      else
		        format.html { render action: "edit" }
		        format.json { render json: @page.errors, status: :unprocessable_entity }
		      end
		    end
		  end

		  # DELETE /pages/1
		  # DELETE /pages/1.json
		  def destroy
		    @page = Page.find(params[:id])
		    
		    respond_with @page.destroy
		  end
		end
	end
end