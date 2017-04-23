class SessionsController < ApplicationController
  before_action :redirect_logged_in_user, only: [:new, :create]
  before_action :require_user, only: [:destroy]

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:error] = 'Incorrect password or email.'
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'You have been logged out.'
    redirect_to root_path
  end
end
