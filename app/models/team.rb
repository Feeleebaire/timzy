class Team < ApplicationRecord
  #validations
  validates :name, presence: true
  #associations
  belongs_to :admin, :class_name => "User"
  has_many :user, through: :teammates
  has_many :users, through: :teammates
  has_many :websites
end
