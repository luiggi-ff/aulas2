require 'test_helper'

class BookingsControllerTest < ActionController::TestCase

  def setup
    sign_in users(:one)
  end
    
  test "should not get index" do
    get(:index)
    assert_response :success
    #assert_not_nil assigns(:all_slots)
    #assert_not_nil assigns(:date)
    #assert_not_nil assigns(:status)
    #assert_not_nil assigns(:resource)
    assert_template :api_not_available
  end
  
    
end
