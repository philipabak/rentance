# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    house_number  { FFaker::AddressCA.building_number }
    street_name   { FFaker::AddressCA.street_name }
    line_2        { FFaker::AddressCA.secondary_address }
    city          { FFaker::AddressCA.city }
    postal_code   { FFaker::AddressCA.postal_code }
    province      { FFaker::AddressCA.province_abbr }
    country       { %w(CA US MX).sample }
  end
end
