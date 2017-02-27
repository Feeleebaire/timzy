class OauthController < ApplicationController

  before_action :skip_authorization
  def authorise
    @team = Team.find(params[:id])
    session[:g_api_team_id] = @team.id # we store team id in session hash
    @client = GoogleApi::Connector.new("https://www.googleapis.com/auth/analytics")
    redirect_to @client.authorization_uri
  end

  def callback
    @team = Team.find(session[:g_api_team_id])
    session[:g_api_team_id] = nil

    if params[:code]
      @client = GoogleApi::Connector.new("https://www.googleapis.com/auth/analytics")
      refresh_token = @client.init_refresh_token(params[:code])
      # @team.update(refresh_token: refresh_token) if refresh_token
      # on affecte le refresh_token a l'admin (current_user)
      current_user.update(refresh_token: refresh_token) if refresh_token
      # raise
      redirect_to set_analytics_team_path(@team)
    end
  end
end
