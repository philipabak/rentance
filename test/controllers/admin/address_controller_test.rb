require 'test_helper'

class Admin::AddressControllerTest < ActionController::TestCase
  setup do
    @request.host = "admin.#{@request.host}"
    Admin::AddressController.any_instance.stubs(:authorize).returns(true)
  end

  test "should get provinces" do
    get :provinces, format: :json
    assert_response :success
  end

  test "should retrieve all provinces for Canada" do
    get :provinces, format: :json, country: 'CA'
    provinces = JSON.parse(response.body)
    assert_equal 13, provinces.count
  end

  test "should not retrieve provinces for non-existent country" do
    get :provinces, format: :json, country: 'ZZ'
    provinces = JSON.parse(response.body)
    assert_equal 0, provinces.count
  end
end
