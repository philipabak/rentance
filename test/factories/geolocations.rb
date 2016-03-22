# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :geolocation do
    latitude    { FFaker::Geolocation.lat.round(7) }
    longitude   { FFaker::Geolocation.lng.round(7) }
  end
end
