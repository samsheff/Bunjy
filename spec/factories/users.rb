# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Dan Druff"
    email "dan@druff.com"
    password "testtest"
    api_key "1234567890asdfghjklasdfghjklasdfghjkl000"
    active true
    balance 0.0
  end
end
