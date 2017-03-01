class NotificationsController < ApplicationController
 skip_after_action :verify_policy_scoped, only: :index
  def index
  @activities = PublicActivity::Activity.order('updated_at DESC')
  end
end
