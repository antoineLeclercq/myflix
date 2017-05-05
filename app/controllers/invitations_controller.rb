class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.invitations.build(invitation_params)

    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "An invitation email has been sent to #{@invitation.recipient_email}"
      redirect_to new_invitation_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end
