class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :edit, :update, :destroy ]
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @teams = current_user.teams
  end

  def show
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
    if @team.save
      @teammate = Teammate.new(user_id: current_user.id, team_id: @team.id, email: current_user.email)
      @teammate.save
      redirect_to new_team_teammate_path(@team)
    else
      render :new
    end
  end

  def edit
    authorize(@team)
  end

  def update
    if @team.update(team_params)
      redirect_to team_path(@team)
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path
  end

  private

  def team_params
    params.require(:team).permit(:name, :admin_id)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
