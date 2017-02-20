class Team < ApplicationRecord
  #validations
  validates :name, presence: true
  #associations
  belongs_to :admin, :class_name => "User", :foreign_key =>"admin_id"
  has_many :teammates
  has_many :websites
end
