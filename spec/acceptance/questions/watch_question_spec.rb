require 'rails_helper'

feature 'Watch question', '
  In order to get question
  As an user
  I want to be able to watch question
' do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User watch question' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(current_path).to eq question_path(question)
  end
end
