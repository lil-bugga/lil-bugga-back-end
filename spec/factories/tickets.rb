FactoryBot.define do
  factory :ticket do
    association :project
    association :user
  end
end
