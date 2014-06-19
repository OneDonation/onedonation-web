require 'test_helper'

class UserMetaControllerTest < ActionController::TestCase
  setup do
    @user_metum = user_meta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_meta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_metum" do
    assert_difference('UserMetum.count') do
      post :create, user_metum: {  }
    end

    assert_redirected_to user_metum_path(assigns(:user_metum))
  end

  test "should show user_metum" do
    get :show, id: @user_metum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_metum
    assert_response :success
  end

  test "should update user_metum" do
    patch :update, id: @user_metum, user_metum: {  }
    assert_redirected_to user_metum_path(assigns(:user_metum))
  end

  test "should destroy user_metum" do
    assert_difference('UserMetum.count', -1) do
      delete :destroy, id: @user_metum
    end

    assert_redirected_to user_meta_path
  end
end
