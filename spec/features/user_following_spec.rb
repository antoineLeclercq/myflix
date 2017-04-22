require 'rails_helper'

feature 'User following' do
  scenario 'user follows and unfollows another user' do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    bob = Fabricate(:user)
    Fabricate(:review, creator: bob, video: video)

    sign_in

    click_on_video_on_home_page(video)

    click_link bob.full_name
    click_button 'Follow'

    visit people_path

    expect(page).to have_content(bob.full_name)

    unfollow(bob)

    expect(page).not_to have_content(bob.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
