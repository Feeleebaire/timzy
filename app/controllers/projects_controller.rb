class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  skip_after_action :verify_policy_scoped, only: :index
  require 'uri'

  def index
    @team = Team.find(params[:id])
  end

  def show
    @comment = Comment.new
    authorize(@project)
    uri = URI::parse(@project.url_targeted)
    @ga = GoogleApi::Analytics.new(@project.team.admin)
    @service = @ga.service
    @datacustom = @service.get_ga_data("ga:#{@project.team.view_id}", "30daysAgo", "yesterday", "ga:goal#{@project.kpi}completions", dimensions: "ga:date")
    @arraycustom = @datacustom.rows
    @graphcustom = []
    @arraycustom.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
      @graphcustom << hash
    end
    @datasession = @service.get_ga_data("ga:#{@project.team.view_id}", "330daysAgo", "yesterday", "ga:sessions", dimensions: "ga:date", filters: "ga:pagePath==/#{uri.path}")
    @arraysession = @datasession.rows
    @graphsession = []
    @arraysession.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
      @graphsession << hash
    end
    @datasuser = @service.get_ga_data("ga:#{@project.team.view_id}", "30daysAgo", "yesterday", "ga:users", dimensions: "ga:date", filters: "ga:pagePath==/#{uri.path}")
    @arrayuser = @datasuser.rows
    @graphuser = []
    @arrayuser.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
      @graphuser << hash
    end
    @datapv = @service.get_ga_data("ga:#{@project.team.view_id}", "30daysAgo", "yesterday", "ga:pageviews", dimensions: "ga:date", filters: "ga:pagePath==/programme/immobilier-neuf/nantes-44-g43619")
    @arraypv = @datapv.rows
    @graphpv = []
    @arraypv.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
    @graphpv << hash
    end
    @databr = @service.get_ga_data("ga:#{@project.team.view_id}", "30daysAgo", "yesterday", "ga:bounceRate", filters: "ga:pagePath==/programme/immobilier/acheteur/liste/44-nantes-44")
    @data_br = [ @databr.rows.first.first.to_f, 100 - @databr.rows.first.first.to_f ]
    @datanv = @service.get_ga_data("ga:#{@project.team.view_id}", "30daysAgo", "yesterday", "ga:percentNewSessions", filters: "ga:pagePath==/programme/immobilier-neuf/nantes-44-g43619")
    @data_nv = [ @datanv.rows.first.first.to_f, 100 - @datanv.rows.first.first.to_f ]
  end

  def new
    @project = Project.new
    @team = Team.find(params[:team_id])
    @ga = GoogleApi::Analytics.new(@team.admin)
    @service = @ga.service
    @kpi = @service.list_goals("#{@team.accountid}","#{@team.webproprietyid}", "#{@team.view_id}")
    authorize(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @team = Team.find(params[:team_id])
    @project.team = @team
    authorize(@project)
    if @project.save
      redirect_to team_path(@team) , notice: 'Your project was successfully created.'
    else
      @ga = GoogleApi::Analytics.new(@team.admin)
      @service = @ga.service
      @kpi = @service.list_goals("#{@team.accountid}","#{@team.webproprietyid}", "#{@team.view_id}")
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project) , notice: 'Your project was successfully updated.'
    else
      render :edit
    end
  end

   def destroy
    @team = Project.find(params[:id]).team
    @project.destroy
    redirect_to team_path(@team), notice: 'Your project was successfully destroyed.'
  end


private

  def project_params
    params.require(:project).permit(:title, :description, :start_date, :end_date, :goal, :kpi, :url_targeted, :category, :user_id, :team_id)
  end

end

  def set_project
    @project = Project.find(params[:id])
    authorize(@project)
  end
