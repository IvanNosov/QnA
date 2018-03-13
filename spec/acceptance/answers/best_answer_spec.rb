require_relative '../acceptance_helper'

feature 'Set the best answer for question', '
  In order to show right answer
  As an Authenticated user
  I want to be able to set best answer as the best answer
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given(:best_answer) { create(:answer, question: question, best: true) }
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    context 'as author' do
      before do
        sign_in user
      end

      context 'one answer' do
        before do
          visit question_path(question)
        end
        scenario 'present best link', js: true do
          within '.question-answers' do
            expect(page).to have_link 'Best'
          end
        end

        scenario ' choose best answer', js: true do
          within '.question-answers' do
            click_on 'Best'
            expect(page).to have_content 'Best answer!'
          end
          expect(current_path).to eq question_path(question)
        end
      end

      scenario ' change best answer', js: true do
        best_answer
        visit question_path(question)

        within "#answer_#{answer.id}" do
          click_on 'Best'
          expect(page).to have_content 'Best'
        end
        expect(current_path).to eq question_path(question)
      end
    end

    scenario 'tries choose best answer for another user question', js: true do
      sign_in another_user
      visit question_path(question)
      expect(page).to_not have_link 'Best'
    end
  end

  scenario 'Not authenticated user tries choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end
end
