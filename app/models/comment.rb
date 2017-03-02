class Comment < ApplicationRecord
  include PublicActivity::Model
  tracked
  #validations
  validates :content, presence: true
  #associations
  belongs_to :project
  belongs_to :user
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

end
