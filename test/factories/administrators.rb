# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :administrator do
    sequence(:name)       { |n| "#{FFaker::Internet.user_name[0, 15]} #{n}" }
    password              { FFaker::String.from_regexp /\w+\w+\w+\w+\w+\w+\w+/ }
    password_confirmation { "#{password}" }
  end
end
