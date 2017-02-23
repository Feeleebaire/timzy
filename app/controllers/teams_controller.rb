class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :edit, :update, :destroy ]
  skip_after_action :verify_policy_scoped, only: :index
  def index
    @teams = current_user.teams
  end

  def show
    @projects = @team.projects
    authorize(@team)
  end

  def new
    @team = Team.new
    authorize(@team)
  end

  def create
    @team = Team.new(team_params)
    authorize(@team)
    @team.admin = current_user
    @team.teammates.build(user: current_user, email: current_user.email)
    if @team.save
      redirect_to authorise_team_path(@team)
      # account_summaries = service.list_account_summaries
      # @teammate = Teammate.new(user_id: current_user.id, team_id: @team.id, email: current_user.email)
      # redirect_to new_team_teammate_path(@team)
    else
      render :new
    end
  end

  def edit
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @accounts = @service.list_accounts
    @accounts_id = []
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

 # def register_website_team
    #team = Team.find(params[:team_id])
   # @service = GoogleApi::Analytics.new(current_user).init_service(team.admin.refresh_token)
    #@accounts = @service.list_account_summaries
 # end

  private

  def team_params
    params.require(:team).permit(:name, :url_targeted, :admin_id)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
