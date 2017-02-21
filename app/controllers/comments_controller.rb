class CommentsController < ApplicationController

def create
  @project = Project.find(params[:project_id])
  @comment = Comment.new(comment_params)
  @comment.project = @project
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
def review_params
    params.require(:comment).permit(:content)
end

end
