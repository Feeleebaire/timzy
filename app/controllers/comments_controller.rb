class CommentsController < ApplicationController

def create
  @project = Project.find(params[:project_id])
  @comment = Comment.new(user: current_user, project: @project)
  authorize @comment
  @comment.save
  redirect_to project_path(@project)
end

def destroy
  @comment.destroy
  redirect_to project_path(@project)
end



end
