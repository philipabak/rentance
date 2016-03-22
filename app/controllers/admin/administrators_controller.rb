class Admin::AdministratorsController < Admin::ResourcesController
  include Authorizable

  private

  def resource_params
    params.require(:administrator).permit(
        :name,
        :password,
        :password_confirmation
    )
  end
end
