class CommentsController < ApplicationController

def create
  @project = Project.find(params[:project_id])
  @comment = Comment.new(comment_params)
  @comment.project = @project
  @comment.user = current_user
  authorize(@comment)
  if @comment.save
    redirect_to project_path(@project)
  else
    render 'projects/show'
  end
end

def destroy
  @comment.destroy
  redirect_to project_path(@project)
end

private
def comment_params
    params.require(:comment).permit(:content)
end

end
