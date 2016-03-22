module Front::BaseHelper
  def body_class
    if controller_name == 'listings' && action_name == 'search'
      'search-body'
    else
      ''
    end
  end
end
