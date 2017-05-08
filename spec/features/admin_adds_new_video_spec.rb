require 'rails_helper'

feature 'Admin adds a new Video' do
  scenario 'admin successfully add a new video' do
    admin = Fabricate(:admin)
    category = Fabricate(:category, name: 'TV Show')

    sign_in(admin)

    visit new_admin_video_path

    fill_in 'Title', with: 'Friends'
    select 'TV Show', from: 'Category'
    fill_in 'Description', with: 'A great TV show full of Friends!'
    attach_file 'Large cover', 'spec/support/uploads/friends_large.png'
    attach_file 'Small cover', 'spec/support/uploads/friends.jpg'
    fill_in 'Video URL', with: 'http://friends.com/friends_video.mp4'

    click_button 'Add Video'

    sign_out
    sign_in

    visit video_path(Video.first)

    expect(page).to have_selector('img[src="/uploads/friends_large.png"]')
    expect(page).to have_selector('a[href="http://friends.com/friends_video.mp4"]')
  end
end
