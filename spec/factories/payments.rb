# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    sender ""
    recipient ""
    amount "9.99"
    description "MyString"
    fee "9.99"
  end
end
