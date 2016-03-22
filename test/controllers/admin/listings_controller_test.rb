require 'test_helper'

class Admin::ListingsControllerTest < ActionController::TestCase
  setup do
    @request.host = "admin.#{@request.host}"
    Admin::ListingsController.any_instance.stubs(:authorize).returns(true)

    @listing = FactoryGirl.create(:listing)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:collection)
  end

  test "should get list of listings by publisher" do
    [@listing.publisher_id, @listing.publisher_id + 1000].each do |publisher_id|
      get :index, publisher_id: publisher_id
      assert_response :success
      assert_equal Listing.by_publisher(publisher_id).count, assigns(:collection).count
    end
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should build new listing with publisher" do
    publisher_id = @listing.publisher_id
    get :new, publisher_id: publisher_id

    resource = assigns(:resource)
    assert_not_nil resource
    assert_equal publisher_id, resource.publisher_id
  end

  test "should create a listing" do
    listing = FactoryGirl.build(:listing, publisher_id: @listing.publisher_id)
    assert_difference 'Listing.count', 1 do
      post :create, listing: resource_params(listing)
    end
    assert_redirected_to admin_listing_url(assigns(:resource).id)
  end

  test "should not create a listing with incorrect params" do
    listing = FactoryGirl.build(:listing, publisher_id: nil)
    assert_no_difference 'Listing.count' do
      post :create, listing: resource_params(listing)
    end
    assert_response :success
  end

  test "should get show" do
    get :show, id: @listing.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @listing.id
    assert_response :success
  end

  test "should update listing" do
    listing = FactoryGirl.build(:listing, publisher_id: @listing.publisher_id)
    assert_no_difference 'Listing.count' do
      patch :update, id: @listing.id, listing: resource_params(listing)
    end
    assert_redirected_to admin_listing_url(assigns(:resource).id)
  end

  test "should not update listing with incorrect params" do
    listing = FactoryGirl.build(:listing, publisher_id: nil)
    assert_no_difference 'Listing.count' do
      patch :update, id: @listing.id, listing: resource_params(listing)
    end
    assert_response :success
  end

  test "should get delete" do
    get :delete, id: @listing.id
    assert_response :success
  end

  test "should destroy listing" do
    assert_difference 'Listing.count', -1 do
      delete :destroy, id: @listing.id
    end
    assert_redirected_to admin_listings_url
  end

  test "should reset listing's slug" do
    friendly_id = @listing.friendly_id
    @listing.title = 'Dummy'
    @listing.save!

    assert_no_difference 'Listing.count' do
      get :reset_slug, id: @listing.id
    end
    listing = Listing.find(@listing.id)
    assert_not_equal friendly_id, listing.friendly_id

    assert_redirected_to admin_listing_url(assigns(:resource).id)
  end

  private

  def resource_params(listing)
    {
        publisher_id: listing.publisher_id,
        title: listing.title,
        description: listing.description,
        published_at: listing.published_at
    }.tap do |hash|
      if listing.address
        hash[:address_attributes] = listing.address.attributes.select{ |k, _| !%w(created_at updated_at).include? k }
      end
      if listing.geolocation
        hash[:geolocation_attributes] = listing.geolocation.attributes.select{ |k, _| %w(latitude longitude).include? k }
      end
    end
  end
end
