class SessionsController < ApplicationController
  def new
  end

  # the create action the params hash has all the information
  # needed to authenticate users by email and password.


  def create
    user = User.find_by(email: params[:session][:email].downcase)   #pulls the user out of the database using the submitted email address.
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
