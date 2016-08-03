class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  include SessionsHelper

  private


  # Recall that we enforced the login requirement using a before
  # filter that called the logged_in_user method . At the time,
  # we needed that method only in the Users controller, but now we
  # find that we need it in the Microposts controller as well,
  # so we’ll move it into the Application controller,
  # which is the base class of all controllers

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end