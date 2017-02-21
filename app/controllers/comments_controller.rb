class CommentsController < ApplicationController

def create
  @project = Project.find(params[:project_id])
  @comment = Comment.new(comment_params)
  @comment.project = @project
  @comment.user = current_user
  authorize(@comment)
  if @comment.save
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.js  # <-- will render `app/views/reviews/create.js.erb`
    end
  else
    respond_to do |format|
      format.html { render 'projects/show' }
      format.js  # <-- idem
    end
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
