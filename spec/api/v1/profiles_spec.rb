require 'rails_helper'

describe "Profile API" do
  describe "get /me" do
    context "unauthorized" do
      it 'returns 401 status if request without access token' do
        params = { format: 'json' }
        get '/api/v1/profiles/me', params: params
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access token is wrong' do
      params = { format: 'json', access_token: '1243456467'}
        get '/api/v1/profiles/me', params: params
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: {format: 'json', access_token: access_token.token}
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains email' do
        expect(response.body).to be_json_eql(me.email.to_json).at_path('email')
      end

      it 'contains id' do
        expect(response.body).to be_json_eql(me.id.to_json).at_path('id')
      end

      it 'does not contain password' do
        expect(response.body).to_not have_json_path('password')
      end

      it 'does not contain encrypted_password' do
        expect(response.body).to_not have_json_path('encrypted_password')
      end
    end
  end  
end
