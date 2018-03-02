require_relative '../acceptance_helper'

feature 'Answer the question', '
  In order to answer for question
  As an Authenticated user
  I want to be able to create answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in user

    visit question_path(question)
    fill_in 'Body', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Give an answer'
    within '.answers' do
      expect(page).to have_content 'Test answer'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
    expect(current_path).to eq question_path(question)
  end
end
