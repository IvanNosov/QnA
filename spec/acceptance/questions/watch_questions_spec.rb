require_relative '../acceptance_helper'

feature 'Watch questions', '
  In order to get all questions
  As an user
  I want to be able to watch questions list
' do
scenario 'User watch questions' do
  visit questions_path
  expect(page).to have_content 'All Questions'
  expect(current_path).to eq questions_path
end

context 'mulitple sessions' do
  given(:user) { create(:user) }

    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
