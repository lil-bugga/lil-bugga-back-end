FactoryBot.define do
  factory :user do
    username { 'useraccount' }
    email { 'user@account.com' }
    password { 'password' }
    password_confirmation { 'password' }
    role { 0 }
  end
end
