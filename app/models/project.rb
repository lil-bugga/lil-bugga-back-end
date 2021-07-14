class Project < ApplicationRecord
  belongs_to :user
  has_many :project_users
  has_many :tickets
  has_one :project_details
end
