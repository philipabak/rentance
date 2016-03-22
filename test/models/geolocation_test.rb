require 'test_helper'

class GeolocationTest < ActiveSupport::TestCase
  test "should be valid with no changes" do
    geolocation = FactoryGirl.build(:geolocation)
    assert geolocation.valid?
  end

  test "should not be valid without latitude" do
    geolocation = FactoryGirl.build(:geolocation, latitude: nil)
    assert_not geolocation.valid?
  end

  test "should not be valid without longitude" do
    geolocation = FactoryGirl.build(:geolocation, longitude: nil)
    assert_not geolocation.valid?
  end

  test "should save geohash (cluster levels) for any coordinates" do
    [-85, -50, -30, 0, 25, 40, 60, 80].each do |lat|
      [-180, -90, -45, 0, 45, 90, 120, 165].each do |lng|
        geolocation = FactoryGirl.create(
            :geolocation,
            latitude:   lat + rand * 10,
            longitude:  lng + rand * 10
        )
        assert geolocation.valid?
        (1..Geolocation::CLUSTER_LEVELS.count).to_a.each do |i|
          assert_not geolocation["cluster_level_#{i}".to_sym].blank?
        end
      end
    end
  end
end
