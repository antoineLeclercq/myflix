require 'rails_helper'

feature 'User resets password' do
  scenario 'user successfully resets password' do
    Sidekiq::Testing.inline! do
      bob = Fabricate(:user, email: 'bob@example.com')
      visit sign_in_path

      send_reset_password_email
      reset_password

      user_should_be_able_to_sign_in(bob)

      clear_email
    end
  end

  def send_reset_password_email
    click_link 'Forgot Password?'

    fill_in 'Email Address', with: 'bob@example.com'
    click_button 'Send Email'
  end

  def reset_password
    open_email('bob@example.com')
    current_email.click_link('here')
    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'
  end

  def user_should_be_able_to_sign_in(user)
    fill_in 'Email Address', with: 'bob@example.com'
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'

    expect(page).to have_content("Welcome, #{user.full_name}")
  end
end
