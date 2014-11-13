require 'test_helper'

class AvailabilitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get(:index,{'resource_id' => "1"})
    assert_response :success
    assert_not_nil assigns(:availability)
  end

end
