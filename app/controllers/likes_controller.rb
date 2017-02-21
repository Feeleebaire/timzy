class LikesController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @like = Like.new(user: current_user, project: @project)
    authorize @like
    @like.save
    redirect_to project_path(@project)
  end

  def destroy
  @like.destroy
  redirect_to project_path(@project)
  end




end
