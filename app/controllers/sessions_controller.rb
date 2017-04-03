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
      flash[:danger] = 'Incorrect password or email.'
      redirect_to :back
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
