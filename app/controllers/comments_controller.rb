class CommentsController < ApplicationController

  # the logged_in_user method is now available in the Comments
  # controller, which means that we can add create and destroy
  # actions and then restrict access to them using a before filter.

  before_action :logged_in_user, only: [:create, :destroy]



  before_action :correct_user,   only: :destroy



  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.create(params[:comment].permit(:content))
    @comment.user_id = current_user.id
    @comment.save
    if @comment.save
        flash[:success] = "Comment created!"
        redirect_to @micropost
    else
      flash.now[:danger] = "error"
    end
  end



  private




  # comment_params permits only the comment’s content attribute
  # to be modified through the web.
  def comment_params
    params.require(:comment).permit(:content)
    redirect_to root_url if @micropost.nil?
  end





end
