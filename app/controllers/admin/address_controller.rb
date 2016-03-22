class Admin::AddressController < Admin::BaseController
  include Authorizable

  def provinces
    @collection = []
    if params[:country].present?
      country = Carmen::Country.coded(params[:country])
      if country && country.subregions?
        @collection = country.subregions
      end
    end
  end
end
