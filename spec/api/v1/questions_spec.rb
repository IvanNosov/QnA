require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like 'API Authenticable' do
      let(:no_token_request) { get '/api/v1/questions', params: { format: :json } }
      let(:bad_token_request) { get '/api/v1/questions', params: { format: :json, access_token: '12346678' } }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable_type: 'Question', commentable_id: question.id) }
      let!(:attachment) { create(:attachment, attachable_type: 'Question', attachable_id: question.id) }

      before do
        get '/api/v1/questions', params: { format: 'json', access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it_behaves_like 'attachments, comments, and answers' do
        let(:path) { '0/' }
        let(:answer_path) { 'answers/0/' }
      end

    end

    describe 'GET /show' do
      let!(:question) { create(:question, id: 1) }

      it_behaves_like 'API Authenticable' do
        let(:no_token_request) { get '/api/v1/questions/1', params: { format: :json } }
        let(:bad_token_request) { get '/api/v1/questions/1', params: { format: :json, access_token: '12346678' } }
      end

      context 'authorized' do
        let(:access_token) { create(:access_token) }
        let!(:answer) { create(:answer, question: question) }
        let!(:comment) { create(:comment, commentable_type: 'Question', commentable_id: question.id) }
        let!(:attachment) { create(:attachment, attachable_type: 'Question', attachable_id: question.id) }

        before { get '/api/v1/questions/1', params: { format: :json, access_token: access_token.token } }

        it 'returns 200 status code' do
          expect(response).to be_success
        end

        %w[id title body created_at updated_at].each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
          end
        end

        it_behaves_like 'attachments, comments, and answers' do
          let(:path) { '' }
          let(:answer_path) { 'answers/0/' }
        end
      end

      describe 'POST /create' do
        it_behaves_like 'API Authenticable' do
          let(:no_token_request) { post '/api/v1/questions/', params: { format: :json } }
          let(:bad_token_request) { post '/api/v1/questions/', params: { format: :json, access_token: '12346678' } }
        end

        context 'authorized' do
          let(:access_token) { create(:access_token) }
          let(:question_params) { attributes_for(:question) }

          before { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: question_params } }

          it 'returns 201 status code' do
            expect(response).to have_http_status :created
          end

          %w[title body].each do |attr|
            it "question object contains #{attr}" do
              expect(response.body).to be_json_eql(question_params[attr.to_sym].to_json).at_path(attr.to_s)
            end
          end

          %w[answers comments attachments].each do |attr|
            context attr do
              it "#{attr} included in question object" do
                expect(response.body).to have_json_size(0).at_path(attr)
              end
            end
          end
        end
      end
    end
  end
end
