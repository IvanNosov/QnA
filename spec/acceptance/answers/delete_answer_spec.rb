require_relative '../acceptance_helper'

feature 'Delete answer', '
  In order to delete my own answer
  As an Authenticated user
  I want to be able to delete my answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete answer', js: true do
    sign_in user
    answer
    visit question_path(question)
    within '.delete-button'
    click_on 'Delete'

    expect(current_path).to eq question_path(question)
  end
end
