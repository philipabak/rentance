require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  test "should be valid with no changes" do
    listing = FactoryGirl.build(:listing)
    assert listing.valid?
  end

  test "should not be valid without an address" do
    listing = FactoryGirl.build(:listing, address: nil)
    assert_not listing.valid?
  end

  test "should not be valid without a geolocation" do
    listing = FactoryGirl.build(:listing, geolocation: nil)
    assert_not listing.valid?
  end

  test "should not be valid without a publisher" do
    listing = FactoryGirl.build(:listing, publisher: nil)
    assert_not listing.valid?
  end

  test "should create address on create" do
    assert_difference ['Listing.count', 'Address.count'], 1 do
      FactoryGirl.create(:listing)
    end
  end

  test "should not create shared address on create" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.address.attributes.select{ |k, _| !%w(id created_at updated_at).include? k }

    assert_difference 'Listing.count', 1 do
      assert_no_difference 'Address.count' do
        FactoryGirl.create(:listing, address_attributes: attributes)
      end
    end
  end

  test "should not create new address on update" do
    listing = FactoryGirl.create(:listing)

    listing.address.country = 'RU'

    assert_no_difference ['Listing.count', 'Address.count'] do
      listing.save!
    end
  end

  test "should not create new address when not changed" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.address.attributes.select{ |k, _| !%w(id created_at updated_at).include? k }
    FactoryGirl.create(:listing, address_attributes: attributes)

    assert_no_difference ['Listing.count', 'Address.count'] do
      listing.save!
    end
  end

  test "should not overwrite shared address on update" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.address.attributes.select{ |k, _| !%w(id created_at updated_at).include? k }
    FactoryGirl.create(:listing, address_attributes: attributes)

    listing.address.country = 'RU'

    assert_no_difference 'Listing.count' do
      assert_difference 'Address.count', 1 do
        listing.save!
      end
    end
  end

  test "should delete address on destroy" do
    listing = FactoryGirl.create(:listing)
    assert_difference ['Listing.count', 'Address.count'], -1 do
      listing.destroy
    end
  end

  test "should not delete shared address on destroy" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.address.attributes.select{ |k, _| !%w(id created_at updated_at).include? k }
    FactoryGirl.create(:listing, address_attributes: attributes)

    assert_difference 'Listing.count', -1 do
      assert_no_difference 'Address.count' do
        listing.destroy
      end
    end
  end

  test "should create geolocation on create" do
    assert_difference ['Listing.count', 'Geolocation.count'], 1 do
      FactoryGirl.create(:listing)
    end
  end

  test "should not create shared geolocation on create" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }

    assert_difference 'Listing.count', 1 do
      assert_no_difference 'Geolocation.count' do
        FactoryGirl.create(:listing, geolocation_attributes: attributes)
      end
    end
  end

  test "should not create new geolocation on update" do
    listing = FactoryGirl.create(:listing)

    listing.geolocation.latitude = listing.geolocation.latitude + 1.0

    assert_no_difference ['Listing.count', 'Geolocation.count'] do
      listing.save!
    end
  end

  test "should not create new geolocation when not changed" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }
    FactoryGirl.create(:listing, geolocation_attributes: attributes)

    assert_no_difference ['Listing.count', 'Geolocation.count'] do
      listing.save!
    end
  end

  test "should not overwrite shared geolocation on update" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }
    FactoryGirl.create(:listing, geolocation_attributes: attributes)

    listing.geolocation.latitude = listing.geolocation.latitude + 1.0

    assert_no_difference 'Listing.count' do
      assert_difference 'Geolocation.count', 1 do
        listing.save!
      end
    end
  end

  test "should delete geolocation on destroy" do
    listing = FactoryGirl.create(:listing)
    assert_difference ['Listing.count', 'Geolocation.count'], -1 do
      listing.destroy
    end
  end

  test "should not delete shared geolocation on destroy" do
    listing = FactoryGirl.create(:listing)

    attributes = listing.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }
    FactoryGirl.create(:listing, geolocation_attributes: attributes)

    assert_difference 'Listing.count', -1 do
      assert_no_difference 'Geolocation.count' do
        listing.destroy
      end
    end
  end
end
