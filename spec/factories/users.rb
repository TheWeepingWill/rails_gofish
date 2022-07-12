FactoryBot.define do
  factory :user do
    name { "Will" }
    email { "will@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
