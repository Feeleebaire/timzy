class Project < ApplicationRecord
<<<<<<< HEAD
  include PublicActivity::Model
  tracked

=======
  acts_as_votable
>>>>>>> master
  #validations
  validates :title, :description, :start_date, :category, presence: true
  #associations
  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :likes


end
