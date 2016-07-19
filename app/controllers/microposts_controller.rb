class MicropostsController < ApplicationController


  # the logged_in_user method is now available in the Microposts
  # controller, which means that we can add create and destroy
  # actions and then restrict access to them using a before filter.

  before_action :logged_in_user, only: [:create, :destroy]

  # We’ll put the resulting find inside a correct_user before filter,
  # which checks that the current user actually has a micropost with
  # the given id.

  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end


  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

  # microposts_params permits only the micropost’s content attribute
  # to be modified through the web.
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end
