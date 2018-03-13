require_relative '../acceptance_helper'

feature 'Edit the answer', '
  In order to edit the answer for question
  As an Authenticated user
  I want to be able to edit answer
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:new_user) { create(:user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'as author' do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'see edit link' do
        within '.question-answers' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit his answer', js: true do
        click_on 'Edit'
        within '.question-answers' do
          fill_in 'Body', with: 'edited answer'
          click_on 'Update'
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end
    end

    scenario 'try to edit not his answer' do
      sign_in new_user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
