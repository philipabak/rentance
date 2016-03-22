class Front::PagesController < Front::BaseController
  def soon
    render layout: 'front/soon'
  end
end
