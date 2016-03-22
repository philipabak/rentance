require 'test_helper'

class Front::ListingsControllerTest < ActionController::TestCase
  setup do
    5.times{ FactoryGirl.create(:listing) }
  end

  test "should get list of geomarkers by age" do
    [1, 5, 10].each do |age|
      date = Time.now - age.days
      geolocations_count = Geolocation.joins(:listings).where(listings: {published_at: date..Time.now}).count
      get :geomarkers, age: age, format: :json
      assert_response :success
      assert_not_nil assigns(:collection)
      assert_equal geolocations_count, assigns(:collection).count
    end
  end

  test "should get list of geomarkers by map bounds and zoom" do
    0.upto(20) do |zoom|
      params = {
          bounds_lat: [FFaker::Geolocation.lat.round(7), FFaker::Geolocation.lat.round(7)].sort,
          bounds_lng: [FFaker::Geolocation.lng.round(7), FFaker::Geolocation.lng.round(7)].sort,
          zoom: zoom
      }

      get :geomarkers, params.merge(format: :json)
      assert_response :success
      assert_not_nil assigns(:collection)
    end
  end

  test "should not get list of geomarkers with no param" do
    get :geomarkers, format: :json
    assert_response 401
  end
end
