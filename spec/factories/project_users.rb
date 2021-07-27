FactoryBot.define do
  factory :project_user do
    association :user
    association :project
  end
end
