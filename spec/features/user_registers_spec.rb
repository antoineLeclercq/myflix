require 'rails_helper'

feature 'User registers and pays for subscription', vcr: true, js: true do
  background { visit register_path }

  scenario 'user registers with valid peronal info and valid card' do
    fill_in_valid_personal_info
    fill_in_valid_card
    click_button 'Sign Up'

    user_should_be_registered
  end

  scenario 'user tries to register with valid personal info and declined card' do
    fill_in_valid_personal_info
    fill_in_declined_card
    click_button 'Sign Up'

    expect(page).to have_content('Your card was declined.')
    user_should_not_be_registered
  end

  scenario 'user tries to register with valid personal info and invalid card' do
    fill_in_valid_personal_info
    fill_in_invalid_card
    click_button 'Sign Up'

    expect(page).to have_content('Your card number is incomplete.')
    user_should_not_be_registered
  end

  scenario 'user tries to register with invalid personal info and valid card' do
    fill_in_invalid_personal_info
    fill_in_valid_card
    click_button 'Sign Up'

    expect(page).to have_content('Invalid user information. Please check the errors below.')
    user_should_not_be_registered
  end

  scenario 'user tries to register with invalid personal and declined card' do
    fill_in_invalid_personal_info
    fill_in_declined_card
    click_button 'Sign Up'

    expect(page).to have_content('Invalid user information. Please check the errors below.')
    user_should_not_be_registered
  end

  scenario 'user tries to register with invalid personal info and invalid card' do
    fill_in_invalid_personal_info
    fill_in_invalid_card
    click_button 'Sign Up'

    expect(page).to have_content('Your card number is incomplete.')
    user_should_not_be_registered
  end

  def fill_in_valid_personal_info
    fill_in 'Email Address', with: 'joe@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Joe Doe'
  end

  def fill_in_valid_card
    stripe_iframe = find('#card-element iframe')
    within_frame stripe_iframe do
      fill_in 'cardnumber', with: '4242424242424242'
      fill_in 'exp-date', with: '07/18'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '10001'
    end
  end

  def fill_in_declined_card
    stripe_iframe = find('#card-element iframe')
    within_frame stripe_iframe do
      fill_in 'cardnumber', with: '4000000000000002'
      fill_in 'exp-date', with: '07/18'
      fill_in 'cvc', with: '123'
      fill_in 'postal', with: '10001'
    end
  end

  def fill_in_invalid_card
    stripe_iframe = find('#card-element iframe')
    within_frame stripe_iframe do
      fill_in 'cardnumber', with: '1234'
      fill_in 'exp-date', with: '07/18'
      fill_in 'cvc', with: '123'
    end
  end

  def fill_in_invalid_personal_info
    fill_in 'Email Address', with: 'joe@example.com'
  end

  def user_should_be_registered
    find_button 'Sign In'
    expect(User.count).to eq(1)
    expect(page).to have_content('You are now registered')
  end

  def user_should_not_be_registered
    expect(User.count).to eq(0)
  end
end
