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

  def self.build_ticket_object_array(data)
    data.as_json.map do |item|
      item[:project_detail] = ProjectDetail.find_by_id(item["project_id"])
      item[:first_entry] = Entry.find_by_ticket_id(item["id"])
      item
    end
  end

  # Method for ticket show, allows transmission of current user role
  def self.build_ticket_object(ticket, user_id)
    response = ticket.as_json
    response[:current_role] = ProjectUser.find_user_in_project(user_id, ticket.project_id)
    response[:entries] = Entry.where(ticket_id: ticket["id"])
    response
  end

  # Method to select all tickets for project ID
  def self.all_for_project(project_id)
    data = where(project_id: project_id)
    build_ticket_object_array(data)
  end

  # Method to select all tickets for user id
  def self.all_for_user(user_id)
    data = where(user_id: user_id)
    build_ticket_object_array(data)
  end

  def self.all_tickets
    data = Ticket.all
    build_ticket_object_array(data)
  end

end
