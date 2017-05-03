require 'rails_helper'

feature 'User resets password' do
  scenario 'user successfully resets password' do
    visit sign_in_path
    click_link 'Forgot Password?'

    bob = Fabricate(:user, email: 'bob@example.com')
    fill_in 'Email Address', with: 'bob@example.com'
    click_button 'Send Email'

    open_email('bob@example.com')
    current_email.click_link('here')

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: 'bob@example.com'
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'

    expect(page).to have_content("Welcome, #{bob.full_name}")

    clear_email
  end
end
