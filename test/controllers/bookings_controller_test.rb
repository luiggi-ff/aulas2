require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  test "should get index" do
    get(:index,{'resource_id' => "1"})
    assert_response :success
    assert_not_nil assigns(:bookings)
  end


end
