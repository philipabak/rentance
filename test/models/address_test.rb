require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "should be valid with no changes" do
    address = FactoryGirl.build(:address)
    assert address.valid?
  end

  test "should not be valid without a house_number" do
    address = FactoryGirl.build(:address, house_number: nil)
    assert_not address.valid?
  end

  test "should not be valid without a street_name" do
    address = FactoryGirl.build(:address, street_name: nil)
    assert_not address.valid?
  end

  test "should not be valid without a postal_code" do
    address = FactoryGirl.build(:address, country: 'CA', postal_code: nil)
    assert_not address.valid?
  end

  test "should not be valid without a city" do
    address = FactoryGirl.build(:address, city: nil)
    assert_not address.valid?
  end

  test "should not be valid without a province" do
    address = FactoryGirl.build(:address, country: 'CA', province: nil)
    assert_not address.valid?
  end

  test "should not be valid without a country" do
    address = FactoryGirl.build(:address, country: nil)
    assert_not address.valid?
  end

  test "should convert to string" do
    address = FactoryGirl.build(:address)
    str = address.to_s
    assert_equal address.house_number, str[address.house_number], "House number is absent"
    assert_equal address.city, str[address.city], "City is absent"
    assert_equal address.postal_code, str[address.postal_code], "Postal code is absent"
  end
end
