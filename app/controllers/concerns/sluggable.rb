module Sluggable
  def reset_slug
    @resource = resource_class.find(params[:id])
    @resource.slug = nil
    @resource.save!

    respond_to do |format|
      format.html do
        flash[:notice] = t 'flash.actions.reset_slug.notice'
        redirect_to url_for(controller: controller_name, action: :show, id: @resource.id)
      end
      format.js do
        flash.now[:notice] = t 'flash.actions.reset_slug.notice'
      end
    end
  end
end
