class LikesController < ApplicationController
  def new
    @like = Like.new
  end

  def create
    @like = Like.new(params[:like])
    like.user = current_user
    @like.project = Project.find(params[:project_id])
    @project = like.project
    @like.save
  end

  private

  params.require(:like).permit(:user_id, :project_id)

end
