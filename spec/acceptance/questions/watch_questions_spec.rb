require 'rails_helper'

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
end
