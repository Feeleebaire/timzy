class Team < ApplicationRecord
  #validations
  validates :name, presence: true
  validates :photo, presence: true
  mount_uploader :photo, PhotoUploader
  #associations
  belongs_to :admin, :class_name => "User"
  has_many :teammates, dependent: :destroy
  has_many :users, through: :teammates
  has_many :projects, dependent: :destroy
  belongs_to :analytic
end
