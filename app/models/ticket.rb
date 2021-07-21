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

  def self.build_ticket_object(data)
    data.map do |item|
      {
        id: item.id,
        project_id: item.project_id,
        project_detail: ProjectDetail.find_by_id(item.project_id),
        first_entry: item.entries.first || { error: "No entries for this ticket" },
        user_id: item.user_id,
        status: item.status,
        created_at: item.created_at,
        updated_at: item.updated_at
       }
    end
  end

  # Method to select all tickets for project ID
  def self.all_for_project(project_id)
    data = where(project_id: project_id)
    build_ticket_object(data)
  end

  # Method to select all tickets for user id
  def self.all_for_user(user_id)
    data = where(user_id: user_id)
    build_ticket_object(data)
  end

  def self.all_tickets
    data = Ticket.all
    build_ticket_object(data)
  end

end
