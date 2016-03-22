require 'test_helper'

class Admin::AdministratorsControllerTest < ActionController::TestCase
  setup do
    @request.host = "admin.#{@request.host}"
    Admin::AdministratorsController.any_instance.stubs(:authorize).returns(true)

    @administrator = FactoryGirl.create(:administrator)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:collection)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create administrator" do
    administrator = FactoryGirl.build(:administrator)
    assert_difference 'Administrator.count', 1 do
      post :create, administrator: resource_params(administrator)
    end
    assert_redirected_to admin_administrator_url(assigns(:resource).id)
  end

  test "should not create administrator with incorrect params" do
    administrator = FactoryGirl.build(:administrator, name: @administrator.name)
    assert_no_difference 'Administrator.count' do
      post :create, administrator: resource_params(administrator)
    end
    assert_response :success
  end

  test "should get show" do
    get :show, id: @administrator.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @administrator.id
    assert_response :success
  end

  test "should update administrator" do
    administrator = FactoryGirl.build(:administrator)
    assert_no_difference 'Administrator.count' do
      patch :update, id: @administrator.id, administrator: resource_params(administrator)
    end
    assert_redirected_to admin_administrator_url(assigns(:resource).id)
  end

  test "should not update administrator with incorrect params" do
    administrator = FactoryGirl.build(:administrator, name: '')
    assert_no_difference 'Administrator.count' do
      patch :update, id: @administrator.id, administrator: resource_params(administrator)
    end
    assert_response :success
  end

  test "should get delete" do
    get :delete, id: @administrator.id
    assert_response :success
  end

  test "should destroy administrator" do
    administrator = FactoryGirl.create(:administrator)
    assert_difference 'Administrator.count', -1 do
      delete :destroy, id: administrator.id
    end
    assert_redirected_to admin_administrators_url
  end

  test "should not destroy last administrator" do
    assert_no_difference 'Administrator.count' do
      delete :destroy, id: @administrator.id
    end
    assert_redirected_to admin_administrators_url
  end

  private

  def resource_params(administrator)
    {
        name: administrator.name,
        password: administrator.password,
        password_confirmation: administrator.password_confirmation
    }
  end
end
