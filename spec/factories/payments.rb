# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    amount 9.99
    description "Test Payment"
    fee "0.0"
  end
end
