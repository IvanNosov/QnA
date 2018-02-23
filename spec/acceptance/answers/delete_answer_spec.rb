require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete my own answer
  As an Authenticated user
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete answer' do
    sign_in user
    answer
    visit question_path(question)
    click_on 'x'

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(current_path).to eq question_path(question)
  end


end