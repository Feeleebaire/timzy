class Teammate < ApplicationRecord
  #associations
  belongs_to :user
  belongs_to :team
end
