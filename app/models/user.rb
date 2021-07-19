class User < ApplicationRecord
  has_secure_password

  has_many :entries
  has_many :tickets
  has_many :projects
  has_many :project_users
  has_many :projects, through: :project_users

  attribute :role, default: 0
  enum role: [:user, :system_administrator]

  validates :username, presence: true
  # Validate email based on preconfigured regex used in MailTo module 
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  # Self method for generating hashed passwords in the seed file
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
