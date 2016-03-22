class Admin::ResourcesController < Admin::BaseController
  include Respondable

  before_action :set_resource, only: [:show, :edit, :update, :destroy, :delete]

  helper_method :resource, :collection

  def resource; @resource end
  def collection; @collection end

  def index
    scope = apply_scopes(resource_class)
    # @collection = scope.respond_to?(:to_a) ? scope.to_a : scope.all
    @collection = scope.page(params[:page] || 1)
  end

  def new
    @resource = resource_class.new
  end

  def create
    @resource = resource_class.create(resource_params)
    respond_smart_with @resource
  end

  def update
    @resource.update(resource_params)
    respond_smart_with @resource
  end

  def destroy
    begin
      @resource.destroy
      respond_smart_with @resource
    rescue Exception => e
      respond_smart_with @resource, alert: e.message
    end
  end

  private

  def resource_class
    @class_name ||= self.class.name.demodulize.sub(/Controller/, '').singularize.constantize
  end

  def set_resource
    @resource = resource_class.find(params[:id])
  end
end
