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

    if @user.save
      handle_invitation
      begin
        Stripe.api_key = ENV['stripe_api_key']
        token = params[:stripeToken]
        charge = StripeWrapper::Charge.create(
          amount: 999,
          description: "Sign up charge for #{@user.email}",
          source: token
        )
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to register_path
      end

      AppMailer.delay.send_welcome_email(@user)
      flash[:success] = 'You are now registered'
      redirect_to sign_in_path
    else
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

  def handle_invitation
    invitation = Invitation.find_by_token(params[:invitation_token])
    if invitation
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
