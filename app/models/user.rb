class User < ApplicationRecord
  has_secure_password

  has_many :entries
  has_many :tickets
  has_many :projects
  has_many :project_users
  has_many :projects, through: :project_users

  enum role: [:user, :system_administrator]
  attribute :role, default: 0

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true

  # Self method for generating hashed passwords in the seed file
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
