# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :publisher do
    sequence(:name) { |n| "#{FFaker::Company.name} #{n}" }
  end
end
