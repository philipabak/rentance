class Front::BaseController < ApplicationController
  before_action :set_debug

  private

  def set_debug; session[:debug] = !params[:debug].nil? end
end
