class User < ApplicationRecord
  has_many :entries
  has_many :tickets
  has_many :projects
  has_many :project_users
  has_many :projects, through: :project_users
end
