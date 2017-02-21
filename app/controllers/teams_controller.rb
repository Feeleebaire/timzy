class TeamsController < ApplicationController


  def show
    @team = Team.find(params[:id])
    authorize(@team)
  end

  def new
    @team = Team.new
    authorize(@team)
  end

  def create
    @team = Team.new(team_params)
    @team.admin = current_user
    authorize(@team)
    @team.save
    redirect_to new_team_teammate_path(@team)
  end

  private

  def team_params
    params.require(:team).permit(:name, :admin_id)
  end

end
