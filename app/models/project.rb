class Project < ApplicationRecord
  #validations
  validates :title, :description, :start_date, :category, presence: true
  #associations
  belongs_to :user
  belongs_to :website
  has_many :comments
  has_many :likes
end
