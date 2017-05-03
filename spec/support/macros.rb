def set_current_user(user=Fabricate(:user))
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)

  visit sign_in_path
  within '.sign_in' do
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
  end
  click_button 'Sign In'
end

def sign_out
  within '.dropdown' do
    click_link 'Sign Out'
  end
end

def click_on_video_on_home_page(video)
  visit home_path
  find("a[href='#{video_path(video)}']").click
end