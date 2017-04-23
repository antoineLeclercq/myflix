class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])

    if user
      AppMailer.send_reset_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? 'You need to specify your email in order to reset your password.' : 'There is no user in our system with this email.'
      redirect_to forgot_password_path
    end
  end
end
