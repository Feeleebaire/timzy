class Teammate < ApplicationRecord
  #associations
  belongs_to :user
  belongs_to :team

  after_create :send_invite_email

  private

  def send_invite_email
    UserMailer.invitation(self).deliver_now
  end
end
