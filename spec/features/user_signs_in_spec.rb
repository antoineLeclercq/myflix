require 'rails_helper'

feature 'User signs in' do
  scenario 'signing in with correct credentials' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content(user.full_name)
  end
end
