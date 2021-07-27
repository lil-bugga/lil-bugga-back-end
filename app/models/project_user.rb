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

  # Validates enum is within enum array
  validates :role, inclusion: { in: :role }

  def self.find_user_in_project(user, project)
    where(user_id: user, project_id: project)
  end

  # Verify user has required permissions on project.
  # Takes a user obj or id, the project_obj or id, and the enum role (string or int)
  def self.verify_role(user_id, project, ver_role)
    user_arr = find_user_in_project(user_id, project)
    user_arr.each { |user| return true if find_role(user.role) >= find_role(ver_role) }
    false
  end

  # Compare enum strings to implicitly return integer valuesf.password_field
  # Return -1 by default because only passed string is likely to be false, and -1 will deny access.
  def self.find_role(user_role)
    case user_role
    when 'client'
      0
    when 'developer'
      1
    when 'admin'
      2
    when 'owner'
      3
    else
      -1
    end
  end
end
