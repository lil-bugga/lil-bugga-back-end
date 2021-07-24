FactoryBot.define do
  factory :project_detail do
    association :project
    project_name { 'test project ' }
  end
end
