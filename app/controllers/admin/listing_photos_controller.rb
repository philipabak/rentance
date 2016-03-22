class Admin::ListingPhotosController < Admin::ResourcesController
  include Authorizable

  def sort
    positions = {}
    params[:photo].each_with_index do |id, index|
      positions[id.to_i] = {position: index + 1}
    end

    ListingPhoto.update(positions.keys, positions.values)

    render nothing: true
  end

  private

  def resource_params
    params.require(:listing_photo).permit(:photo).tap do |hash|
      hash[:listing_id] = params[:listing_id].to_i  if params[:listing_id]
    end
  end
end
