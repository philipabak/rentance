class Admin::ErrorsController < Admin::BaseController
  def show
    status_code = params[:code] || 500
    render status_code.to_s, status: status_code
  end
end
