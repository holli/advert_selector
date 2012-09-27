require 'test/test_helper'

class ExamplesControllerTest < ActionController::TestCase

  # TESTING MAINLY AdvertSelector::ApplicationHelper methods
  # TESTING MAINLY AdvertSelector::ApplicationHelper methods

  test "render video once per session" do
    get :index
    assert_response :success

    #binding.pry

  end

end
