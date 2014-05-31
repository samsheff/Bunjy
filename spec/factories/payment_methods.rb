# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_method do
    method_type "MyString"
    stripe_token "MyString"
    user nil
  end
end
