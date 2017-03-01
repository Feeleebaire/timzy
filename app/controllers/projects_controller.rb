class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  skip_after_action :verify_policy_scoped, only: :index
  require 'uri'

  def show
    @comment = Comment.new
    authorize(@project)
    uri = URI::parse(@project.url_targeted)
    @startdate = params[:startdate].blank? ? "30daysAgo" : params[:startdate]
    @enddate = params[:enddate].blank? ? "yesterday" : params[:enddate]
    @ga = GoogleApi::Analytics.new(@project.team.admin)
    @service = @ga.service
    # SET GOALS KPI
    @kpigoal = @service.list_goals("#{@project.team.accountid}","#{@project.team.webproprietyid}", "#{@project.team.view_id}")
    @kpi = params[:kpi].blank? ? @project.kpi : params[:kpi]

    if !@kpi.blank?
      @datacustom = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:goal#{@kpi}completions", dimensions: "ga:date")
      @arraycustom = @datacustom.rows
      @graphcustom = []
      @arraycustom.each do |data|
        hash = {}
        hash[:x] = data[0]
        hash[:y] = data[1]
        @graphcustom << hash
      end
      @custom_dates = set_dates_for_graph(@arraycustom)
    end

    # SET EVENT KPI
    @kpievent = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:totalEvents", dimensions: "ga:eventAction")

    if !@kpievent.rows.blank?
      @event = params[:event].blank? ? @kpievent.rows.first.first : params[:event]
      @datacustomevent = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:totalEvents", dimensions: "ga:date", filters: "ga:eventAction==#{@event}")
      @arraycustomevent = @datacustomevent.rows
      @graphcustomevent = []
      @arraycustomevent.each do |data|
        hash = {}
        hash[:x] = data[0]
        hash[:y] = data[1]
        @graphcustomevent << hash
      end
      @customevent_dates = set_dates_for_graph(@arraycustomevent)
    end

    # Basic Metrics
    if uri.path.blank?
      @datasession = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:sessions", dimensions: "ga:date")
      @datasuser = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:users", dimensions: "ga:date")
      @datapv = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:pageviews", dimensions: "ga:date")
      @databr = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:bounceRate")
      @datanv = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:percentNewSessions")
    else
      @datasession = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:sessions", dimensions: "ga:date", filters: "ga:pagePath=@#{uri.path}")
      @datasuser = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:users", dimensions: "ga:date", filters: "ga:pagePath=@#{uri.path}")
      @datapv = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:pageviews", dimensions: "ga:date", filters: "ga:pagePath=@#{uri.path}")
      @databr = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:bounceRate", filters: "ga:pagePath=@#{uri.path}")
      @datanv = @service.get_ga_data("ga:#{@project.team.view_id}", "#{@startdate}", "#{@enddate}", "ga:percentNewSessions", filters: "ga:pagePath=@#{uri.path}")
    end

    @arraysession = @datasession.rows
    @graphsession = []
    @arraysession.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
      @graphsession << hash
    end
    @session_dates = set_dates_for_graph(@arraysession)

    @arrayuser = @datasuser.rows
    @graphuser = []
    @arrayuser.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
      @graphuser << hash
    end
    @user_dates = set_dates_for_graph(@arrayuser)

    @arraypv = @datapv.rows
    @graphpv = []
    @arraypv.each do |data|
      hash = {}
      hash[:x] = data[0]
      hash[:y] = data[1]
    @graphpv << hash
    end
    @pv_dates = set_dates_for_graph(@arraypv)

    @data_br = [ @databr.rows.first.first.to_f, 100 - @databr.rows.first.first.to_f ]

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


  def set_project
    @project = Project.find(params[:id])
    authorize(@project)
  end

  def set_dates_for_graph(data)
    @array_date = data.map do |array|
      array[0]
    end
    @array_date_updated = []
    @array_date.each do |date|
      @array_date_updated << DateTime.parse(date).to_date.strftime("%0e-%m-%y")
    end
    return @array_date_updated
  end
end
