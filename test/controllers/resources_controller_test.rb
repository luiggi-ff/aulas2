require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

 # test "should create resource" do
 #   assert_difference('Resource.count') do
 #     post :create, resource: {name: 'res1', description: 'res1'}
 #   end
 #
 #   assert_redirected_to article_path(assigns(:resource))
 # end

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
