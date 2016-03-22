# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :listing_photo do
    photo { fixture_file_upload("#{Rails.root}/test/factories/test.jpg", 'image/jpeg') }
    association :listing
    sequence(:position) { |n| n + 1 }
  end
end
