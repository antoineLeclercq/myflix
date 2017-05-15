class UserSignup
  attr_accessor :status, :error_message
  attr_reader :user

  def initialize(user)
    @user = user
    @status = nil
    @error_message = nil
  end

  def sign_up(stripe_token, invitation_token)
    if user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        description: "Sign up charge for #{@user.email}",
        source: stripe_token
      )

      if charge.successful?
        user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(user)
        self.status = :success
      else
        self.status = :failed
        self.error_message = charge.error_message
      end
    else
      self.status = :failed
      self.error_message = 'Invalid user information. Please check the errors below.'
    end

    self
  end

  def successful?
    status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by_token(invitation_token)
    if invitation
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end
