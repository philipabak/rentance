ThinkingSphinx::Index.define :listing, with: :active_record do
  indexes :title
  indexes :description

  has geolocation.id,  as: :geolocation_id
  has 'RADIANS(geolocations.latitude)',  as: :latitude,  type: :float
  has 'RADIANS(geolocations.longitude)', as: :longitude, type: :float

  has :published_at

  # group_by 'geolocations.latitude', 'geolocations.longitude'

  set_property field_weights: {
                   title: 5,
                   description: 3
               }
end
