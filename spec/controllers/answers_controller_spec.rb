require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer of question in the database' do
        expect do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer, question: question) }, format: :js
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:invalid_answer) }, format: :js
        end.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }
    before { answer }
    let!(:user_answer) { create(:answer, question: question, user: @user) }

    it 'deletes user answer' do
      expect do
        delete :destroy, params: { question_id: question,
                                   id: user_answer }
      end.to change(Answer, :count).by(-1)
    end

    it 'fail delete another\'s user answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }
        .to change(Answer, :count).by(0)
    end

    it 'redirect to question view' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
