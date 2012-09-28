require_dependency "advert_selector/application_controller"

module AdvertSelector
  class BannersController < ApplicationController
    # GET /banners
    # GET /banners.json
    def index
      @banners = Banner.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @banners }
      end
    end
  
    # GET /banners/1
    # GET /banners/1.json
    def show
      redirect_to edit_banner_url(params[:id])

      #@banner = Banner.find(params[:id])
      #
      #respond_to do |format|
      #  format.html # show.html.erb
      #  format.json { render :json => @banner }
      #end
    end
  
    # GET /banners/new
    # GET /banners/new.json
    def new
      @banner = Banner.new

      @banner.start_time = Time.now.at_midnight
      @banner.end_time = 1.week.from_now.end_of_day
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @banner }
      end
    end
  
    # GET /banners/1/edit
    def edit
      @banner = Banner.find(params[:id])
    end
  
    # POST /banners
    # POST /banners.json
    def create
      @banner = Banner.new(params[:banner])
  
      respond_to do |format|
        if @banner.save
          format.html { redirect_to @banner, :notice => 'Banner was successfully created.' }
          format.json { render :json => @banner, :status => :created, :location => @banner }
        else
          format.html { render :action => "new" }
          format.json { render :json => @banner.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # PUT /banners/1
    # PUT /banners/1.json
    def update
      @banner = Banner.find(params[:id])
  
      respond_to do |format|
        if @banner.update_attributes(params[:banner])
          format.html { redirect_to @banner, :notice => 'Banner was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @banner.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # DELETE /banners/1
    # DELETE /banners/1.json
    def destroy
      @banner = Banner.find(params[:id])
      @banner.destroy
  
      respond_to do |format|
        format.html { redirect_to banners_url }
        format.json { head :no_content }
      end
    end
  end
end
