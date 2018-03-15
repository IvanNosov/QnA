require_relative '../acceptance_helper'

feature 'User sign in using facebook', '
  In order to be able to ask question
  As an user
  I want to be able to sign in using facebook
' do

  background do
    visit new_user_session_path
  end

  scenario 'User try to sign in using facebook' do
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'You have to confirm your email address before continuing.'
  end
end
