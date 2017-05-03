require 'rails_helper'

feature 'User invites a friend' do
  scenario 'user successfully invites a friend and the invitation is accepted' do
    bob = Fabricate(:user)
    sign_in(bob)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow_inviter(bob)
    inviter_should_follow_friend(bob)

    clear_email
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
    click_button 'Sign Up'
  end

  def friend_signs_in
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
