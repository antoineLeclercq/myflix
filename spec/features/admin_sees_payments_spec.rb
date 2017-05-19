require 'rails_helper'

feature 'Admin sees payments' do
  background do
    bob = Fabricate(:user, email: 'bob@example.com', full_name: 'Bob Doe')
    Fabricate(:payment, amount: 999, user: bob)
  end

  scenario 'admin can see payments made by users' do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content('$9.99')
    expect(page).to have_content('bob@example.com')
    expect(page).to have_content('Bob Doe')
  end

  scenario 'user cannot see payments made by users' do
    joe = Fabricate(:user)
    sign_in(joe)
    visit admin_payments_path
    expect(page).to have_content('You are not authorized to do that')
  end
end
