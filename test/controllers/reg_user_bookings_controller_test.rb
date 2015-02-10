require 'test_helper'

class BookingsControllerTest < ActionController::TestCase

  def setup
    sign_in users(:two)

  end
    
#regla	                        1	5	3
#admin?	                        -	SI	-
#Resource=0	                    SI	-	NO
#user=current	                SI	NO	SI
#VALID?			
#			
#all status – allow to book?	NO	NO	SI
#by_user_template	            SI	SI	NO  
    
    
  test "admin should get own bookings" do
    get(:index, resource_id: '0')
    assert_response :success
    assert_not_nil assigns(:user_bookings)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    assert_template :index_by_user
  end

    test "admin should get all slots for resource" do
    get(:index, resource_id: '1')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    #assert_not_includes( assigns(:allowed_status), 'all' , ['all is not an allowed status'] )
    assert_template :index_list
  end
    
    
  test "regular user should not get other user bookings" do
    get(:index, user_id: users(:one).id )
    assert_response :success
    assert_not_nil assigns(:user_bookings)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    #  assert_not_includes( assigns(:allowed_status), 'all' , ['all is not an allowed status'] )
    assert_template :index_by_user
  end
    
 

   
end
