FactoryBot.define do
  factory :game do
    player_count { 2 }
    sequence :name do |n|
      "Example Game #{n}" 
    end
    users { [] }

    trait :started do 
      started_at { DateTime.current }
    end
  end
end