class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #validations
  validates :first_name, :last_name, :role,  presence: true
  #associations
  has_many :teams, class_name: "Team", :foreign_key =>"admin_id"
  has_many :teammates
  has_many :admin_id
  has_many :projects
  has_many :comments
end
