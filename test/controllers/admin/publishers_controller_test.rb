require 'test_helper'

class Admin::PublishersControllerTest < ActionController::TestCase
  setup do
    @request.host = "admin.#{@request.host}"
    Admin::PublishersController.any_instance.stubs(:authorize).returns(true)

    @publisher = FactoryGirl.create(:publisher)
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

  test "should create publisher" do
    publisher = FactoryGirl.build(:publisher)
    assert_difference 'Publisher.count', 1 do
      post :create, publisher: resource_params(publisher)
    end
    assert_redirected_to admin_publisher_url(assigns(:resource).id)
  end

  test "should not create publisher with incorrect params" do
    publisher = FactoryGirl.build(:publisher, name: '')
    assert_no_difference 'Publisher.count' do
      post :create, publisher: resource_params(publisher)
    end
    assert_response :success
  end

  test "should get show" do
    get :show, id: @publisher.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @publisher.id
    assert_response :success
  end

  test "should update publisher" do
    publisher = FactoryGirl.build(:publisher)
    assert_no_difference 'Publisher.count' do
      patch :update, id: @publisher.id, publisher: resource_params(publisher)
    end
    assert_redirected_to admin_publisher_url(assigns(:resource).id)
  end

  test "should not update publisher with incorrect params" do
    publisher = FactoryGirl.build(:publisher, name: '')
    assert_no_difference 'Publisher.count' do
      patch :update, id: @publisher.id, publisher: resource_params(publisher)
    end
    assert_response :success
  end

  test "should get delete" do
    get :delete, id: @publisher.id
    assert_response :success
  end

  test "should destroy publisher" do
    assert_difference 'Publisher.count', -1 do
      delete :destroy, id: @publisher.id
    end
    assert_redirected_to admin_publishers_url
  end

  private

  def resource_params(publisher)
    {
        name: publisher.name
    }
  end
end
