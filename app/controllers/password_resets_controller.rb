class PasswordResetsController < ApplicationController
  def show
    user = User.find_by_token(params[:id])

    if user
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by_token(params[:token])
    redirect_to(expired_token_path) && return unless user

    user.password = params[:password]

    if user.save
      user.generate_token
      user.save
      flash[:success] = 'Your password was successfully reset. Please sign in with your new password.'
      redirect_to sign_in_path
    else
      flash[:error] = 'The password you entered is invalid, please chose another password.'
      redirect_to password_reset_path(user)
    end
  end
end
