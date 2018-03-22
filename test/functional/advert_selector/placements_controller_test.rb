require File.dirname(__FILE__) + '/../../test_helper'

module AdvertSelector
  class PlacementsControllerTest < ActionController::TestCase
    # fixtures :all

    setup do
      AdvertSelector.admin_access_class = AdvertSelector::AdminAccessClassAlwaysTrue
      @routes = AdvertSelector::Engine.routes # This would be same as calling get :index, :use_route => :advert_selector

      @placement = advert_selector_placements(:leaderboard)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:placements)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create placement" do
      assert_difference('Placement.count') do
        #post :create, :placement => { :conflicting_placements_array => @placement.conflicting_placements_array, :name => @placement.name }
        post :create, params: {:placement => { :name => "new placement" }}
      end
  
      assert_redirected_to placement_path(assigns(:placement))
    end
  
    test "should show placement" do
      get :show, params: {:id => @placement}
      assert_response :redirect
    end
  
    test "should get edit" do
      get :edit, params: {:id => @placement}
      assert_response :success
    end
  
    test "should update placement" do
      put :update, params: {:id => @placement, :placement => { :name => @placement.name }}
      #assert_redirected_to placement_path(assigns(:placement))
      assert_redirected_to placement_path(assigns(:placement))
    end
  
    test "should destroy placement" do
      assert_difference('Placement.count', -1) do
        delete :destroy, params: {:id => @placement}
      end
  
      assert_redirected_to placements_path
    end
  end
end
