require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase

  def setup
    sign_in users(:one)
    Dbc.get("/dbc_start")
  end

  def teardown
      Dbc.get("/dbc_clean")
  end 
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
    assert_template :index
  end

  test "should not create resource" do
    post :create
      assert_response :redirect
      assert_equal "El Aula no pudo ser creada", flash[:error] 
  end

  test "should create resource" do
    post(:create, {name: 'Some title', description: 'some description'})
    assert_redirected_to resources_path(assigns(:resources))
  end


  test "should show resource 3" do
    get(:show, {'id' => "3"})
    assert_response :success
    assert_not_nil assigns(:resource)
  end

  test "should edit resource 3" do
    get(:edit, {'id' => "3"})
    assert_response :success
    assert_not_nil assigns(:resource)
  end
    
  test "should delete resource 3" do
    get(:destroy, {'id' => "3"})
    assert_response :redirect
    assert_equal "El Aula fue eliminada exitosamente", flash[:notice]
  end

  test "should update resource 3" do
    get(:update, {'id' => "1", 'name' => 'Aula 5', 'description' => "aula 5"})
    assert_response :redirect
    assert_equal "El Aula fue modificada exitosamente", flash[:notice]
    assert_equal "Aula 5", assigns(:resource).name
    assert_equal "aula 5", assigns(:resource).description
  end

  test "should not update resource 500" do
    get(:update, {'id' => "500", 'name' => 'other name', 'description' => "some other description"})
    assert_response :redirect
    assert_equal "El Aula no pudo ser modificada", flash[:error]
    assert_nil assigns(:resource)
  end



end
