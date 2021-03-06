class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page])

  end


  def display_user
    @user = current_user
    render json: @user
  end



  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Twitter Clone!"
      render json: @user
    else
      render json: @user
    end
  end



  # To get the delete links to work, we need to add a destroy action
  # which finds the corresponding user and destroys it with the
  # Active Record destroy method, finally redirecting to the users
  # index.Because users have to be logged in to delete users, the code
  # below adds :destroy to the logged_in_user before filter.

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user

    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  def show_all_users
    @user = User.all
    render json: @user
  end




  private

  def user_params
    params.require(:user).permit(:name, :email,:about_me, :password,
                                 :password_confirmation)
  end

  # Confirms an admin user.
  def admin_user
  redirect_to(root_url) unless current_user.admin?

  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)

  end


end
