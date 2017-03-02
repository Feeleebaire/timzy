class Project < ApplicationRecord

  include PublicActivity::Model
  tracked

  acts_as_votable

  #validations
  validates :title, :description, :start_date, :category, presence: true
  #associations
  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

end
