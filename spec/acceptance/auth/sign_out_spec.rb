require 'rails_helper'

feature 'User sign out', '
  In order to be able to look for question and answers
  As an user
  I want to be able to sign out
' do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in user
    visit questions_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to_not have_content 'Sign out'
    expect(current_path).to eq root_path
  end

  scenario 'Not-registered user try to sign out' do
    visit questions_path

    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Sign in'
  end
end
