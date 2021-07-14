class ProjectDetail < ApplicationRecord
  belongs_to :project

  validates :project_name, presence: true, uniqueness: true
  validates :description, default: "No description available"
end
