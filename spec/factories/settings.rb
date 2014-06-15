# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    setting_name "test"
    setting_value "value"
    data_type "string"
  end
end
