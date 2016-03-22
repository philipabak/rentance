# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    association :address,     strategy: :build
    association :geolocation, strategy: :build
    association :publisher,   strategy: :build
    title         { FFaker::Job.title }
    description   { FFaker::Lorem.paragraphs.join("\n") }
    published_at  { Time.now - rand(10).days }
  end
end
