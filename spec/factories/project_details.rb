FactoryBot.define do
  factory :project_detail do
    association :project
    project_name { 'test project ' }
    description { 'This is a test project description' }
    status {  }
  end
end
