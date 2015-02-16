require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    sign_in users(:one)
  end


  test "should get list of users" do
    get(:index)
    assert_response :success
    #  byebug
    assert_not_nil assigns(:users)
    assert_template :index
  end

end
