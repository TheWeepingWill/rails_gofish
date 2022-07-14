FactoryBot.define do
  factory :user do
    name { "Will" }
    sequence :email do |n|
      "will#{n}@example.com" 
    end
    password { 'password' }
    password_confirmation { 'password' }
  end
end
