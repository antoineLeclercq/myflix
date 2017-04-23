class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: 'info@myflix.com', subject: 'Welcome to Myflix!'
  end

  def send_reset_password_email(user)
    @user = user
    mail to: user.email, from: 'info@myflix.com', subject: 'Reset your password'
  end
end
