require 'rails_helper'

feature 'User invites a friend' do
  scenario 'user successfully invites a friend and the invitation is accepted', js: true, vcr: true do
    Sidekiq::Testing.inline! do
      bob = Fabricate(:user)
      sign_in(bob)

      invite_a_friend
      friend_accepts_invitation
      friend_signs_in

      friend_should_follow_inviter(bob)
      inviter_should_follow_friend(bob)

      clear_email
    end
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: 'Joe Joe'
    fill_in "Friend's Email Address", with: 'joe@example.com'
    click_button 'Send Invitation'

    expect(page).to have_content('invitation email has been sent to joe@example.com')
    sign_out
  end

  def friend_accepts_invitation
    open_email 'joe@example.com'
    current_email.click_link 'here'

    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Joe Joe'

    stripe_iframe = find('#card-element iframe')
    within_frame stripe_iframe do
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '07/18'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '10001'
    end

    click_button 'Sign Up'
  end

  def friend_signs_in
    # needed because of previous JS asynchronous call with stripe
    # with `find` Capybara waits for the page to load before trying to fill in fields
    find('#email')

    fill_in 'Email Address', with: 'joe@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
  end

  def friend_should_follow_inviter(inviter)
    click_link 'People'
    expect(page).to have_content(inviter.full_name)
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    click_link 'Sign In'
    sign_in(inviter)

    click_link 'People'
    expect(page).to have_content('Joe Joe')
  end
end
