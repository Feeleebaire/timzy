class Project < ApplicationRecord
  #validations
  validates :title, :description, :start_date, :category, presence: true
  #associations
  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :likes

  def self.search(search)

    where("title ILIKE ? OR description ILIKE ?", "%#{search}%", "%#{search}%")
  end

end
