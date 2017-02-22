class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :edit, :update, :destroy ]
  skip_after_action :verify_policy_scoped, only: :index
  require 'signet/oauth_2/client'

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
    authorize(@team)
    @team.admin = current_user
    @team.teammates.build(user: current_user, email: current_user.email)
    if @team.save
      # @teammate = Teammate.new(user_id: current_user.id, team_id: @team.id, email: current_user.email)
      @client = Signet::OAuth2::Client.new(
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
        client_id: ENV['OAUTH_CLIENT_ID'],
        client_secret: ENV['OAUTH_CLIENT_SECRET'],
        scope: "https://www.googleapis.com/auth/analytics.readonly",
        redirect_uri: 'http://localhost:3000/oauth2callback'
      )
      redirect_to @client.authorization_uri.to_s
      # redirect_to new_team_teammate_path(@team)
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
