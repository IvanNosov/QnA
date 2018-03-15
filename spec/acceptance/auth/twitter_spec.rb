require_relative '../acceptance_helper'

feature 'User sign in using twitter', '
  In order to be able to ask question
  As an user
  I want to be able to sign in using twitter
' do

  background do
    clear_emails
    visit new_user_session_path
  end

  scenario 'User try to sign in using facebook' do
    click_on 'Sign in with Twitter'
    fill_in 'Email', with: 'test@example.com'
    click_on 'Confirm'
    expect(page).to have_content 'We have sent a mail, please check your email'

    open_email('test@example.com')
    current_email.click_link 'here'
    expect(page).to have_content 'You successfully confirmed your mail and twitter account'
    expect(current_path).to eq root_path
  end
end
