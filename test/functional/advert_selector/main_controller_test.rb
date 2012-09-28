require 'test_helper'

module AdvertSelector
  class MainControllerTest < ActionController::TestCase

    setup do
      AdvertSelector.admin_access_class = AdvertSelector::AdminAccessClassAlwaysTrue
      @routes = AdvertSelector::Engine.routes # This would be same as calling get :index, :use_route => :advert_selector
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should clear errors log" do
      AdvertSelector::ErrorsCache.add('str')
      get :clear_errors_log
      assert_response :redirect
      assert AdvertSelector::ErrorsCache.errors.blank?
    end

    test "forbidden with default access" do
      AdvertSelector.admin_access_class = AdvertSelector::AdminAccessClassDefault
      get :index
      assert_response 403
    end
  
  end
end
