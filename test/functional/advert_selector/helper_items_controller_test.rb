require 'test_helper'

module AdvertSelector
  class HelperItemsControllerTest < ActionController::TestCase
    setup do
      @helper_item = helper_items(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:helper_items)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create helper_item" do
      assert_difference('HelperItem.count') do
        post :create, :helper_item => { :content => @helper_item.content, :content_for => @helper_item.content_for, :master_id => @helper_item.master_id, :master_type => @helper_item.master_type, :name => @helper_item.name }
      end
  
      assert_redirected_to helper_item_path(assigns(:helper_item))
    end
  
    test "should show helper_item" do
      get :show, :id => @helper_item
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, :id => @helper_item
      assert_response :success
    end
  
    test "should update helper_item" do
      put :update, :id => @helper_item, :helper_item => { :content => @helper_item.content, :content_for => @helper_item.content_for, :master_id => @helper_item.master_id, :master_type => @helper_item.master_type, :name => @helper_item.name }
      assert_redirected_to helper_item_path(assigns(:helper_item))
    end
  
    test "should destroy helper_item" do
      assert_difference('HelperItem.count', -1) do
        delete :destroy, :id => @helper_item
      end
  
      assert_redirected_to helper_items_path
    end
  end
end
