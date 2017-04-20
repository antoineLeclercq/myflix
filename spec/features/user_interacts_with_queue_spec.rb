require 'rails_helper'

feature 'User interacts with queue' do

  scenario 'user adds and reorders videos in the queue' do
    movies = Fabricate(:category, name: 'Movies')
    inception = Fabricate(:video, title: 'Inception', category: movies)
    iron_man = Fabricate(:video, title: 'Iron Man', category: movies)
    blood_diamond = Fabricate(:video, title: 'Blood Diamond', category: movies)

    sign_in

    add_video_to_queue(inception)
    expect_video_to_be_in_queue(inception)

    visit video_path(inception)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue(iron_man)
    add_video_to_queue(blood_diamond)

    set_video_position(inception, 3)
    set_video_position(iron_man, 1)
    set_video_position(blood_diamond, 2)
    update_queue

    expect_video_position(inception, 3)
    expect_video_position(iron_man, 1)
    expect_video_position(blood_diamond, 2)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='#{video_path(video)}']").click
    click_link '+ My Queue'
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content('+ My Queue')
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in 'queue_items[][position]', with: position
    end
  end

  def update_queue
    click_on 'Update Instant Queue'
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq("#{position}")
  end
end
