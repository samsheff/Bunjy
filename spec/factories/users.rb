# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Dan Druff"
    email "dan@druff.com"
    active true
    balance 0.0
  end
end
