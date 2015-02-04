require 'test_helper'

class BookingsControllerTest < ActionController::TestCase

  def setup
    sign_in users(:one)
  end
    
  test "should get own_bookings_index" do
    
    get(:index, resource_id: '0')
    assert_response :success
    assert_not_nil assigns(:user_bookings)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    assert_template :index_by_user
  end

    
    
#  test "should get calendar_index" do
#    get(:index, resource_id: '1', view:'calendar')
#    assert_response :success
#    assert_not_nil assigns(:all_slots)
#    assert_not_nil assigns(:date)
#    assert_not_nil assigns(:status)
#    assert_not_nil assigns(:resource)
#    assert_template :index_calendar
#  end
    
  test "should get list_index" do
    get(:index, resource_id: '1')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    assert_not_nil assigns(:resource)
    assert_template :index_list
  end
    
  test "should create booking" do
      get :new,  resource_id: '1', from: '2015-05-01 10:00:00', to: '2015-05-01 11:00:00', user: users(:one).id
      assert_redirected_to bookings_path(resource_id: '1')
      #assert_not_nil assigns(:resource)
      #assert_not_nil assigns(:booking)
      #assert_not_nil flash[:notice]
  end
    
  test "should not create booking" do
      get :new, resource_id: '1', from: '2015-01-01 10:00', to: '2015-01-01 11:00', user: users(:one).id
      assert_redirected_to bookings_path(resource_id: '1')
      #assert_not_nil assigns(:resource)
      #assert_not_nil assigns(:booking)
      assert_not_nil flash[:error]
  end

    test "should not create booking2" do
      get :new, resource_id: '1', user: users(:one).id
      assert_redirected_to bookings_path(resource_id: '1')
      #assert_not_nil assigns(:resource)
      #assert_not_nil assigns(:booking)
      assert_not_nil flash[:error]
  end
    
    
end
