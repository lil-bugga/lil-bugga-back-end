class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :entries, dependent: :destroy

  # Allows integer to represent ticket status with :open?, :todo?, :in_progress?, :complete, and :closed? method checks
  # Add more to array as more status' are required. NB: order matters, append only unless db will be dropped
  attribute :status, default: 0 # Default ticket to open unless specified
  enum status: %i[open todo in_progress complete closed]

  # Validates enum is within enum array
  validates :status, inclusion: { in: :status }

  # Method to select all tickets for project ID
  def self.all_for_project(project_id)
    where(project_id: project_id)
  end
  
  # Method to select all tickets for user id
  def self.all_for_user(user_id)
    where(user_id: user_id)
  end

end
