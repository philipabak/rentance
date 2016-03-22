class Front::ListingsController < Front::BaseController
  def search
  end

  def show
    @resource = Listing.friendly.find(params[:friendly_id])
  end

  def list
    unless %w(age cluster city province).any?{ |p| params[p].present? }
      render json: {error: "Missing parameter"}, status: :unauthorized
      return
    end

    @collection, @total_count = Listing.list(params)
  end

  def geomarkers
    unless %w(age zoom).any?{ |p| params[p].present? }
      render json: {error: "Missing parameter"}, status: :unauthorized
      return
    end

    @collection = Geolocation.geomarkers(params)
  end
end
