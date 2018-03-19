require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if request without access token' do
        get '/api/v1/questions', params: { format: 'json' }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access token is wrong' do
        get '/api/v1/questions', params: { format: 'json', access_token: '1243456467' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

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

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    describe 'GET /show' do
      let!(:question) { create(:question, id: 1) }
      context 'unauthorized' do
        it 'returns 401 status if request without access token' do
          get '/api/v1/questions', params: { format: 'json' }
          expect(response.status).to eq 401
        end
        it 'returns 401 status if access token is wrong' do
          get '/api/v1/questions', params: { format: 'json', access_token: '1243456467' }
          expect(response.status).to eq 401
        end
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

        context 'answers' do
          it 'included in question object' do
            expect(response.body).to have_json_size(1).at_path('answers')
          end

          %w[id body created_at updated_at best].each do |attr|
            it "answer object contains #{attr}" do
              expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
            end
          end
        end

        context 'comments' do
          it 'included in question object' do
            expect(response.body).to have_json_size(1).at_path('comments')
          end

          %w[id body user_id].each do |attr|
            it "comment object contains #{attr}" do
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end
        end

        context 'attachments' do
          it 'included in question object' do
            expect(response.body).to have_json_size(1).at_path('attachments')
          end

          it 'attachment object contains url' do
            expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/file/url')
          end
        end
      end

      describe 'POST /create' do
        context 'unauthorized' do
          it 'returns 401 status if request without access token' do
            get '/api/v1/questions', params: { format: 'json' }
            expect(response.status).to eq 401
          end
          it 'returns 401 status if access token is wrong' do
            get '/api/v1/questions', params: { format: 'json', access_token: '1243456467' }
            expect(response.status).to eq 401
          end
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

          context 'answers' do
            it 'included in question object' do
              expect(response.body).to have_json_size(0).at_path('answers')
            end
          end

          context 'comments' do
            it 'included in question object' do
              expect(response.body).to have_json_size(0).at_path('comments')
            end
          end

          context 'attachments' do
            it 'included in question object' do
              expect(response.body).to have_json_size(0).at_path('attachments')
            end
          end
        end
      end
    end
  end
end
