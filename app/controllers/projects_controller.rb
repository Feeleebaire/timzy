class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = policy_scope(Project) # project.all
  end

  def show
  end

  def new
    @project = Project.new
    authorize(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    authorize(@project)

    if @project.save
      redirect_to @project , notice: 'Your project was successfully created.'

    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project , notice: 'Your project was successfully edited.'
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
