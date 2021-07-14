class User < ApplicationRecord
  has_secure_password

  has_many :entries
  has_many :tickets
  has_many :projects
  has_many :project_users
  has_many :projects, through: :project_users

  enum role: [:user, :system_administrator]
  attribute :role, default: 0

  validates :email, presence: true, uniqueness: true
end
