class UsersController < ApplicationController
  before_action :redirect_logged_in_user, only: [:new, :create, :new_with_invitation_token]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    sign_up_result = UserSignup.new(@user).sign_up(params[:stripe_token], params[:invitation_token])

    if sign_up_result.successful?
      flash[:success] = 'You are now registered'
      redirect_to sign_in_path
    else
      flash[:error] = sign_up_result.error_message
      render :new
    end
  end

  def show
    @user = User.find_by_token(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
