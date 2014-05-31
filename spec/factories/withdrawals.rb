# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :withdrawal do
    payment_method ""
    user nil
    amount "9.99"
  end
end
