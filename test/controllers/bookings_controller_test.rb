require 'test_helper'

class BookingsControllerTest < ActionController::TestCase

  def setup
    sign_in users(:one)
    
    Dbc.get("/dbc_start")
  end

  def teardown
      Dbc.get("/dbc_clean")
  end 
    
  test "should get list_index" do
    get(:index, resource_id: '1')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_not_nil assigns(:status)
    assert_not_nil assigns(:resource)
    assert_template :index
  end

  test "should get list_index with status all" do
    get(:index, resource_id: '1', status: 'all')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_equal 'all', assigns(:status)
    assert_not_nil assigns(:resource)
    assert_template :index
  end
  
  test "should get list_index with status pending" do
    get(:index, resource_id: '1', status: 'pending')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_equal 'pending', assigns(:status)
    assert_not_nil assigns(:resource)
    assert_template :index
  end
    
  test "should get list_index with status approved" do
    get(:index, resource_id: '1', status: 'approved')
    assert_response :success
    assert_not_nil assigns(:all_slots)
    assert_not_nil assigns(:date)
    assert_equal 'approved', assigns(:status)
    assert_not_nil assigns(:resource)
    assert_template :index
  end  
    
  test "should create booking" do
      post :new,  resource_id: '1', start: '2015-07-01 14:00:00', finish: '2015-07-01 15:00:00', user_id: users(:one).id
      assert_redirected_to bookings_path
      assert_response :redirect
      assert_not_nil assigns(:resource)
      assert_equal 1, assigns(:resource).id
      assert_not_nil assigns(:booking)
      assert_equal 'pending', assigns(:booking).status
      assert_equal DateTime.parse('2015-07-01 14:00:00'), DateTime.parse(assigns(:booking).from)
      assert_equal DateTime.parse('2015-07-01 15:00:00'), DateTime.parse(assigns(:booking).to)
      assert_equal 'La Reserva fue guardada exitosamente', flash[:notice]
  end

    
  test "should not create booking" do
      get :new, resource_id: '1', from: '2015-01-01 10:00', to: '2015-01-01 11:00', user_id: users(:one).id
      assert_redirected_to bookings_path#(resource_id: '1', user_id: users(:one).id)
      assert_not_nil flash[:error]
  end

    test "should not create booking2" do
      get :new, resource_id: '1', user_id: users(:one).id
      assert_redirected_to bookings_path
      assert_not_nil flash[:error]
  end
     
    test "should  reject booking" do
      get(:destroy, {'resource_id' => "1", 'id' => "599"})
      assert_redirected_to bookings_path
      assert_response :redirect
      assert_not_nil assigns(:resource)
      assert_equal 1, assigns(:resource).id
      assert_equal "La Reserva fue rechazada exitosamente", flash[:notice]     
  end

  test "should cancel booking" do
      get(:destroy, {'resource_id' => "1", 'id' => "592"})
      assert_redirected_to bookings_path
      assert_response :redirect
      assert_not_nil assigns(:resource)
      assert_equal 1, assigns(:resource).id
      assert_equal "La Reserva fue cancelada exitosamente", flash[:notice]     
  end  

  test "should approve booking" do
      get :update, resource_id: '1', id: '594'
      assert_equal 'approved', assigns(:booking).status
      assert_equal "La Reserva fue aprobada", flash[:notice]
  end    

  test "should not approve booking" do
      get :update, resource_id: '87687', id: '596'
      assert_equal "La Reserva no pudo ser aprobada",  flash[:error]
  end    
  
    
end
