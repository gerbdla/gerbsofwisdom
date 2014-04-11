require 'test_helper'

class UsmapsControllerTest < ActionController::TestCase
  setup do
    @usmap = usmaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:usmaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create usmap" do
    assert_difference('Usmap.count') do
      post :create, usmap: {  }
    end

    assert_redirected_to usmap_path(assigns(:usmap))
  end

  test "should show usmap" do
    get :show, id: @usmap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @usmap
    assert_response :success
  end

  test "should update usmap" do
    put :update, id: @usmap, usmap: {  }
    assert_redirected_to usmap_path(assigns(:usmap))
  end

  test "should destroy usmap" do
    assert_difference('Usmap.count', -1) do
      delete :destroy, id: @usmap
    end

    assert_redirected_to usmaps_path
  end
end
