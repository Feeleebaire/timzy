class Project < ApplicationRecord
  #validations
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :category, presence: true
  #associations
  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :likess

end
