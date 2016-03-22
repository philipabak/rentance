json.array!(@collection) do |resource|
  json.title          pluralize(resource['listings_count'].to_i, 'listing')
  json.latitude       resource['latitude'].to_f
  json.longitude      resource['longitude'].to_f
  json.cluster        resource['cluster']
  json.listings_count resource['listings_count'].to_i
end
