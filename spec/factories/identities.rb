# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    uid "12345"
    provider "facebook"
    user nil
  end
end
