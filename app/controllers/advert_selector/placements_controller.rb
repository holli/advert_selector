require_dependency "advert_selector/application_controller"

module AdvertSelector
  class PlacementsController < ApplicationController
    # GET /placements
    # GET /placements.json
    def index
      @placements = Placement.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @placements }
      end
    end
  
    # GET /placements/1
    # GET /placements/1.json
    def show
      redirect_to edit_placement_url(params[:id])

      #@placement = Placement.find(params[:id])
      #
      #respond_to do |format|
      #  format.html # show.html.erb
      #  format.json { render :json => @placement }
      #end
    end
  
    # GET /placements/new
    # GET /placements/new.json
    def new
      @placement = Placement.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @placement }
      end
    end
  
    # GET /placements/1/edit
    def edit
      @placement = Placement.find(params[:id])
    end
  
    # POST /placements
    # POST /placements.json
    def create
      @placement = Placement.new(params[:placement])
  
      respond_to do |format|
        if @placement.save
          format.html { redirect_to @placement, :notice => 'Placement was successfully created.' }
          format.json { render :json => @placement, :status => :created, :location => @placement }
        else
          format.html { render :action => "new" }
          format.json { render :json => @placement.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # PUT /placements/1
    # PUT /placements/1.json
    def update
      @placement = Placement.find(params[:id])
  
      respond_to do |format|
        if @placement.update_attributes(params[:placement])
          format.html { redirect_to @placement, :notice => 'Placement was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @placement.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # DELETE /placements/1
    # DELETE /placements/1.json
    def destroy
      @placement = Placement.find(params[:id])
      @placement.destroy
  
      respond_to do |format|
        format.html { redirect_to placements_url }
        format.json { head :no_content }
      end
    end
  end
end
