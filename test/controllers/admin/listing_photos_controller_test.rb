require 'test_helper'

class Admin::ListingPhotosControllerTest < ActionController::TestCase
  setup do
    @request.host = "admin.#{@request.host}"
    Admin::ListingPhotosController.any_instance.stubs(:authorize).returns(true)

    @listing = FactoryGirl.create(:listing)

    @listing_photos = []
    3.times do |i|
      @listing_photos << FactoryGirl.create(:listing_photo, listing_id: @listing.id, position: i + 1)
    end
  end

  teardown do
    @listing_photos.each do |cp|
      cp.photo.destroy
      cp.destroy
    end
    @listing.destroy
  end

  test "should create photo" do
    photo = FactoryGirl.create(:listing_photo)
    assert_difference 'ListingPhoto.count', 1 do
      post :create, format: :js, listing_id: photo.listing.id, listing_photo: resource_params(photo)
    end
    photo.photo.destroy
  end

  test "should destroy photo" do
    photo = FactoryGirl.create(:listing_photo)
    assert_difference 'ListingPhoto.count', -1 do
      delete :destroy, format: :js, listing_id: photo.listing.id, id: photo.id
    end
    photo.photo.destroy
  end

  test "should sort photos" do
    new_order = [@listing_photos[2].id, @listing_photos[0].id, @listing_photos[1].id]

    post :sort, listing_id: @listing.id, photo: new_order
    assert_response :success

    new_order.each_with_index do |id, index|
      cp = ListingPhoto.find(id)
      assert_equal index + 1, cp.position, "Sorting didn't work"
    end
  end

  private

  def resource_params(photo)
    {
        listing_id: photo.listing_id,
        photo: File.new("#{Rails.root}/test/factories/test.jpg", 'r')
    }
  end
end
