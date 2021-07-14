class Project < ApplicationRecord
  belongs_to :user
  has_many :project_users
  has_many :tickets
  has_one :project_details, dependent: :destroy
  accepts_nested_attributes_for :project_details

  enum status: [:open, :closed]
  attribute :status, default: 0
end
