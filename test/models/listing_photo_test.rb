require 'test_helper'

class ListingPhotoTest < ActiveSupport::TestCase
  setup do
    @listing_photo = FactoryGirl.create(:listing_photo)
  end

  teardown do
    @listing_photo.photo.destroy
    @listing_photo.destroy
  end

  test "should be valid" do
    assert @listing_photo.valid?, "Invalid after creation"
  end

  test "should have photo file" do
    assert File.exist?(@listing_photo.photo.path), "File doesn't exist"
  end

  test "should be invalid without a file" do
    listing_photo = FactoryGirl.build(:listing_photo, photo: nil)
    assert !listing_photo.valid?, "Listing photo file is not being validated"
  end
end
