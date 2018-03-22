require_relative '../acceptance_helper'

feature 'Search data', '
    In order to find searched string
    As an user
    I want to be able to search data
  ' do

    given!(:question) { create(:question, title: 'Test question') }
    given!(:answer) { create(:answer, body: 'Test answer') }
    given!(:comment) { create(:comment, body: 'Test comment', commentable: question) }
    given!(:user) { create(:user, email: 'test@user.com') }

    describe 'Searching for All' do
      it 'search all', sphinx: true do
        ThinkingSphinx::Test.index
        visit questions_path
        fill_in 'query', with: 'Test'
        click_on 'Search'
        save_and_open_page

        within '.results' do
          expect(page).to have_content('Test question')
          expect(page).to have_content('Question')
          expect(page).to have_content('Test answer')
          expect(page).to have_content('Answer')
          expect(page).to have_content('Test comment')
          expect(page).to have_content('Comment')
          expect(page).to have_content('test@user.com')
          expect(page).to have_content('User')
        end
      end
    end
  end
