require 'rails_helper'

feature 'User signs in' do
  scenario 'signing in with correct credentials' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content(user.full_name)
  end

  scenario 'deactivated user tries to sign in' do
    bob = Fabricate(:user, active: false, full_name: 'Bob Doe')
    sign_in(bob)
    expect(page).not_to have_content('Bob Doe')
    expect(page).to have_content('Your account has been suspended. Please contact Customer Service.')
  end
end
