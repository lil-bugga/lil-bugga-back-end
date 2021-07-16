class ProjectDetail < ApplicationRecord
  belongs_to :project

  validates :project_name, presence: true, uniqueness: true
  # Set default description if none passed
  # Note: Sending a blank string will set a blank description
  attribute :description, default: "No description available"
end
