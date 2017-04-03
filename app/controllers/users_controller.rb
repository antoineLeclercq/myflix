class UsersController < ApplicationController
  before_action :redirect_logged_in_user, only: [:new, :create]

  def new
    if logged_in?
      redirect_to home_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'You are now registered'
      redirect_to sign_in_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
