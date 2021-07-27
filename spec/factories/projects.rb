FactoryBot.define do
  factory :project do
    association :user
    status { 0 }
  end
end
