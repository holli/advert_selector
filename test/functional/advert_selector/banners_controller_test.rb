require File.dirname(__FILE__) + '/../../test_helper'

module AdvertSelector
  class BannersControllerTest < ActionController::TestCase
    setup do
      AdvertSelector.admin_access_class = AdvertSelector::AdminAccessClassAlwaysTrue
      @routes = AdvertSelector::Engine.routes # This would be same as calling get :index, :use_route => :advert_selector

      @banner = advert_selector_banners(:pepsi)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:banners)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create banner" do
      assert_difference('Banner.count') do
        post :create, :banner => { :comment => @banner.comment, :end_time => @banner.end_time, :frequency => @banner.frequency, :name => @banner.name, :placement_id => @banner.placement_id, :start_time => @banner.start_time, :target_view_count => @banner.target_view_count }
      end
  
      assert_redirected_to banner_path(assigns(:banner))
    end
  
    test "should show banner" do
      get :show, :id => @banner
      assert_response :redirect
    end
  
    test "should get edit" do
      get :edit, :id => @banner
      assert_response :success
    end
  
    test "should update banner" do
      put :update, :id => @banner, :banner => { :comment => @banner.comment }
      assert_redirected_to banner_path(assigns(:banner))
    end

    test "should update banner running view count" do
      @banner.add_one_viewcount
      @banner.save
      put :update_running_view_count, :id => @banner, :banner => { :running_view_count => 99 }
      assert_response :redirect
      assert_equal 99, @banner.running_view_count
      assert_equal 99, AdvertSelector::Banner.find(@banner)[:running_view_count]

    end
  
    test "should destroy banner" do
      assert_difference('Banner.count', -1) do
        delete :destroy, :id => @banner
      end
  
      assert_redirected_to banners_path
    end
  end
end
