require 'test_helper'

class Admin::AuthControllerTest < ActionController::TestCase
  setup do
    @administrator = FactoryGirl.create(:administrator)
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should authorize with correct credentials" do
    post :login, name: @administrator.name, password: @administrator.password

    assert_equal @administrator.id, session[:administrator_id]
    assert_redirected_to admin_root_url
  end

  test "should not authorize with incorrect credentials" do
    post :login, name: @administrator.name, password: ''

    assert_nil session[:administrator_id]
    assert_response :success
  end

  test "should logout administrator" do
    session[:administrator_id] = 1
    get :logout

    assert_nil session[:administrator_id]
    assert_redirected_to admin_login_url
  end
end
