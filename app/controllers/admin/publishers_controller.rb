class Admin::PublishersController < Admin::ResourcesController
  include Authorizable

  private

  def resource_params
    params.require(:publisher).permit(
        :name
    )
  end
end
