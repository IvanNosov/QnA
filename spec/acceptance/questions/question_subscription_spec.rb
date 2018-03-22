require_relative '../acceptance_helper'

feature 'Get updates of question to email', '
  In order to get question updates
  As an authenticated user
  I want to be able to subscribe/unsubscribe to question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:subscription) { create(:subscription, user: user, question: question) }

    background { sign_in user }

    scenario 'subscribe for question' do
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_content 'Subscribed!'
    end

    scenario 'unsubscribe from question' do
      subscription
      visit question_path(question)
      click_on 'Unsubscribe'
      expect(page).to have_content 'Unsubscribed!'
    end
  end

  describe 'Non-authenticated user' do
    scenario 'Subscribe button is not present' do
      visit question_path(question)
      expect(page).to_not have_button 'Subscribe'
    end
  end
end
