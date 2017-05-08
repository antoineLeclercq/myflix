require 'rails_helper'

feature 'User reviews a video' do
  scenario 'user successfully reviews an existing video' do
    bob = Fabricate(:user, full_name: 'Bob Joe')
    category = Fabricate(:category)
    friends = Fabricate(:video, title: 'Friends', category: category)

    sign_in(bob)

    click_on_video_on_home_page(friends)

    select '5 Stars', from: 'Rate this video'
    fill_in 'Write Review', with: 'Best TV show ever!'
    click_button 'Submit Review'

    expect(page).to have_content('Rating: 5 / 5')
    expect(page).to have_content('Best TV show ever!')
    expect(page).to have_content('by Bob Joe')
  end
end
