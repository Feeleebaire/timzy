class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = policy_scope(Project) # project.all
  end

  def show
    @comment = Comment.new
    #authorize(@project)
  end

  def new
    @project = Project.new
    @website = Website.find(params[:website_id])
    @team = Team.find(params[:team_id])
    authorize(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @website = Website.find(params[:website_id])
    @team = Team.find(params[:team_id])
    @project.website = @website
    authorize(@project)

    if @project.save
      redirect_to team_website_path(@team, @website) , notice: 'Your project was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project , notice: 'Your project was successfully updated.'
    else
      render :edit
    end
  end

   def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Your project was successfully destroyed.'
  end


private

  def project_params
    params.require(:project).permit(:title, :description, :start_date, :end_date, :goal, :kpi, :url_targeted, :category, :user_id, :website_id)
  end

end

  def set_project
    @project = Project.find(params[:id])
    authorize(@project)
  end
