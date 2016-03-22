module Respondable
  private

  def respond_smart_with(resource, msg = {}, location = nil)
    if resource.respond_to?(:errors) && !resource.errors.empty?
      case action_name.to_sym
        when :create
          render action: :new
        when :update
          render action: :edit
        when :destroy
          render action: :delete
        else
          render action: :index
      end
    else
      resource_name = resource.respond_to?(:resource_name) ? resource.resource_name : 'Resource'
      case action_name.to_sym
        when :create
          notice = t 'flash.actions.create.notice', resource_name: resource_name
          action = :show
        when :update
          notice = t 'flash.actions.update.notice', resource_name: resource_name
          action = :show
        when :destroy
          notice = t 'flash.actions.destroy.notice', resource_name: resource_name
          action = :index
        else
          action = :index
      end
      respond_to do |format|
        format.html do
          if msg.empty?
            flash[:notice] = notice if notice
          else
            msg.each{ |key, value| flash[key] = value }
          end
          if params[:return_path].present?
            redirect_to params[:return_path]
          elsif location
            redirect_to location
          elsif action == :index
            redirect_to url_for(controller: controller_name, action: action)
          else
            redirect_to url_for(controller: controller_name, action: action, id: resource.id)
          end
        end
        format.js do
          if msg.empty?
            flash.now[:notice] = notice if notice
          else
            msg.each{ |key, value| flash.now[key] = value }
          end
        end
      end
    end
  end
end
