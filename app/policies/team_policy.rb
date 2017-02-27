class TeamPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    is_user_team_member?
  end

  def show?
    is_user_team_member?
  end

  def new?
    true
  end

  def create?
    true
  end

  # @project  <=> record
  # current_user <=> user
  def update?
    is_user_admin?
  end

  def destroy?
    is_user_admin?
  end

  def set_analytics?
    is_user_admin?
  end

  def save_analytics?
    is_user_admin?
  end

  private

  def is_user_admin?
    record.admin == user
  end

  def is_user_team_member?
    record.users.include? user
  end

end
