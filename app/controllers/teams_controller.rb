class TeamsController < ApplicationController
  before_action :set_team, only: [ :show, :edit, :update, :destroy, :set_analytics, :save_analytics ]
  skip_after_action :verify_policy_scoped, only: :index
  def index
    @teams = current_user.teams
  end

  def show
    @team_projects = @team.projects
    # display show according to research (or not)
    if params[:search]
      @projects = @team_projects.search(params[:search])
    else
      @projects = @team_projects.all
    end

    authorize(@team)
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @datas = @service.get_ga_data("ga:#{@team.view_id}", "30daysAgo", "yesterday", "ga:users", dimensions: "ga:date")
    big_array = @datas.rows
    @array_clean = big_array.map do |array|
        array[1]
    end
    @array_date = big_array.map do |array|
      array[0]
    end
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
    authorize(@team)
  end

  def update
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @props = @service.list_web_properties(params[:accountid])
    authorize(@team)
    if @team.update(team_params)
      respond_to do |format|
        format.html { redirect_to edit_team_path(@team) }
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path
  end

  def set_analytics
    authorize(@team)
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @accounts = @service.list_accounts
    @props = []
    @views = []
    # @webprops = @service.list_web_properties(@team.accountid) unless @team.accountid.blank?
    # @views = @service.list_profiles(@team.accountid, @team.webproprietyid) if !@team.accountid.blank? && !@team.webproprietyid.blank?
  end

  def save_analytics
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @accounts = @service.list_accounts
    if !params[:view_id].blank?
      @team.update(accountid: params[:accountid], webproprietyid: params[:webproprietyid], view_id: params[:view_id])
    elsif !params[:webproprietyid].blank?
      @team.update(accountid: params[:accountid], webproprietyid: params[:webproprietyid])
      @views = @service.list_profiles(params[:accountid], params[:webproprietyid]).items
    elsif !params[:accountid].blank?
      @team.update(accountid: params[:accountid])
      @props = @service.list_web_properties(params[:accountid]).items
      @views = []
    end
  end
  private

  def team_params
    params.require(:team).permit(:name, :url_targeted, :admin_id, :accountid, :webproprietyid, :view_id)
  end

  def set_team
    @team = Team.find(params[:id])
    authorize(@team)
  end
end
