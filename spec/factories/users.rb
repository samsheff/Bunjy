# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "facebook"
    uid "12345678998"
    name "Dan Druff"
    balance 0.0
  end
end
