require 'rails_helper'

feature 'User sign up', '
  In order to ask question
  As an user
  I want to be able to sign up
' do

  scenario 'Sign up with valid data' do
    visit new_user_session_path

    click_on 'Sign up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content('A message with a confirmation link has been sent to your email address.')
    expect(current_path).to eq root_path
  end

  scenario 'Sign up with invalid data' do
    visit new_user_session_path

    click_on 'Sign up'

    fill_in 'Password', with: '1234'
    fill_in 'Password confirmation', with: '123456'

    click_button 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content('Password is too short (minimum is 6 characters)')
    expect(current_path).to eq user_registration_path
  end
end
