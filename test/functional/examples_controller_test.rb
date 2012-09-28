require File.dirname(__FILE__) + '/../test_helper'

class ExamplesControllerTest < ActionController::TestCase

  test "render video once per session" do
    get :index
    assert_response :success

    #binding.pry

  end

end
