class Admin::ListingsController < Admin::ResourcesController
  include Authorizable
  include Sluggable

  has_scope :by_publisher,  as: :publisher_id
  has_scope :by_city,       as: :city

  def new
    @resource = Listing.new
    country = 'CA'
    if params[:publisher_id]
      publisher = Publisher.find_by(id: params[:publisher_id])
      @resource.publisher_id = publisher.id  if publisher
    else
      publisher = Publisher.first
      @resource.publisher_id = publisher.id  if publisher
    end
    @resource.build_address(country: country)
    @resource.build_geolocation
  end

  private

  def resource_params
    params.require(:listing).permit(
        :publisher_id,
        :title,
        :description,
        :published_at,
        address_attributes: [
            :id,
            :house_number,
            :street_name,
            :line_2,
            :city,
            :postal_code,
            :province,
            :country
        ],
        geolocation_attributes: [
            :id,
            :latitude,
            :longitude
        ]
    )
  end
end
