class Entry < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :subject, presence: true
  validates :body, presence: true

  def self.all_for_ticket(ticket_id)
    where(ticket_id: ticket_id)
  end
end
