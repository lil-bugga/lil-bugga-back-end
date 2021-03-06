class Project < ApplicationRecord
  after_create :set_owner

  belongs_to :user
  has_many :project_users, dependent: :destroy
  has_many :tickets, dependent: :destroy
  # Project details will be deleted when projects are deleted
  has_one :project_detail, dependent: :destroy
  # Accept project details through the project controller, do not create if no params are passed
  # and allow patch methods on project details throught the project controller
  accepts_nested_attributes_for :project_detail, reject_if: :all_blank, update_only: true
  accepts_nested_attributes_for :project_users

  # Allows integer to represent ticket status with :open? and :closed? method checks
  # Add more to array as more status' are required. NB: order matters, append only unless db will be dropped
  attribute :status, default: 0 # Default ticket to open unless specified
  enum status: %i[open closed]

  # Validates enum is within enum array
  validates :status, inclusion: { in: :status }

  def self.build_project_object(project, user_id)
    response = project.as_json
    response[:project_detail] = project.project_detail
    response[:project_users] = project.project_users.map do |user|
      data = user.as_json
      data[:username] = User.find_by_id(user[:user_id]).username
      data
    end
    response[:current_role] = ProjectUser.find_user_in_project(user_id, project)
    response
  end

  def set_owner
    project_users.create(user_id: user_id, role: 'owner')
  end

  def self.all_for_user(user_id)
    project_users = ProjectUser.where(user_id: user_id)
    project_users.map { |x| Project.find_by_id(x.project_id) }
  end
end
