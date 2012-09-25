require 'test_helper'

module AdvertSelector
  class BannersControllerTest < ActionController::TestCase
    setup do
      @banner = banners(:one)
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
        post :create, :banner => { :comment => @banner.comment, :confirmed => @banner.confirmed, :delay_requests => @banner.delay_requests, :end_time => @banner.end_time, :frequency => @banner.frequency, :name => @banner.name, :placement_id => @banner.placement_id, :start_time => @banner.start_time, :target_view_count => @banner.target_view_count }
      end
  
      assert_redirected_to banner_path(assigns(:banner))
    end
  
    test "should show banner" do
      get :show, :id => @banner
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, :id => @banner
      assert_response :success
    end
  
    test "should update banner" do
      put :update, :id => @banner, :banner => { :comment => @banner.comment, :confirmed => @banner.confirmed, :delay_requests => @banner.delay_requests, :end_time => @banner.end_time, :frequency => @banner.frequency, :name => @banner.name, :placement_id => @banner.placement_id, :start_time => @banner.start_time, :target_view_count => @banner.target_view_count }
      assert_redirected_to banner_path(assigns(:banner))
    end
  
    test "should destroy banner" do
      assert_difference('Banner.count', -1) do
        delete :destroy, :id => @banner
      end
  
      assert_redirected_to banners_path
    end
  end
end
