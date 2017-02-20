class Comment < ApplicationRecord
  #validations
  validates :content, presence: true
  #associations
  belongs_to :project
  belongs_to :user
end
