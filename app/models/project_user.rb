class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, presence: true
  validates :role, presence: true
  validates :project_id, presence: true

  # Confirms the user does not already have an assigned role on the project
  validates_uniqueness_of :user_id, scope: :project_id, message: 'User is already assigned to this project'

  attribute :role, default: 0
  enum role: %i[client developer admin owner]

  validates :role, numericality:
  {greater_than_or_equal_to: 0, less_than_or_equal_to: 3}

  def self.find_user_in_project(user_id, project_id)
    where(user_id: user_id, project_id: project_id)
  end
end
