require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

#  test "should create resource" do
#    post(:create, {name: 'res1', description: 'res1'})
#    assert_redirected_to resources_path
#  end

  test "should not create resource" do
    post :create
    assert_response :success
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
