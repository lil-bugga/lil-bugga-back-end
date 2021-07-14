class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :entries
end
