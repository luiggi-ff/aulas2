require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  def setup
    sign_in users(:one)
  end    
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  test "should not create resource" do
    post :create
    assert_response :success
  end

  test "should create resource" do
    post(:create, {name: 'Some title', description: 'some description'})
    assert_redirected_to resources_path(assigns(:resources))
  end


  test "should show resource 1" do
    get(:show, {'id' => "1"})
    assert_response :success
    assert_not_nil assigns(:resource)
  end

  test "should edit resource 1" do
    get(:edit, {'id' => "1"})
    assert_response :success
    assert_not_nil assigns(:resource)
  end

end
