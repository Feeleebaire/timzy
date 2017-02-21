class TeammatesController < ApplicationController
  def new
    @teammate = Teammate.new
  end

  def create
    teammate = Teammate.new(teammate_params)
    teammate.save
  end

  private

  def teammate_params
    params.require(:teammate).permit(:email, :team_id)
  end
end
