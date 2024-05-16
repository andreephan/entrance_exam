require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST #sign_up' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        { email: 'test@example.com', password: 'password', firstName: 'first', lastName: 'last' }
      end
      it 'creates a new user' do
        expect { post :sign_up, params: valid_attributes }.to change(User, :count).by(1)
      end

      it 'returns a success response' do
        post :sign_up, params: valid_attributes
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post :sign_up, params: { user: { email: 'test@example.com' } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #sign_in' do
    context 'with valid credentials' do
      let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

      it 'returns a success response' do
        post :sign_in, params: { email: 'test@example.com', password: 'password' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a token and refresh token' do
        post :sign_in, params: { email: 'test@example.com', password: 'password' }
        expect(response.body).to include('token')
        expect(response.body).to include('refreshToken')
      end
    end

    context 'with invalid credentials' do
      it 'returns an error response' do
        post :sign_in, params: { email: 'test@example.com', password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #sign_out' do
    let!(:user) { create(:user) }
    before do
      post :sign_in, params: { email: user.email, password: user.password }
      @token = JSON.parse(response.body)['token']
    end
    it 'returns a no content response' do
      request.headers['Authorization'] = "Bearer #{@token}"
      post :sign_out
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST #refresh_token' do
    context 'with a valid refresh token' do
      let!(:user) { create(:user) }
      let!(:token) { create(:token, user: user, expiredAt: Time.current + 1.hour) }

      it 'returns a success response' do
        post :refresh_token, params: { refreshToken: token.refreshToken }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a new token and refresh token' do
        post :refresh_token, params: { refreshToken: token.refreshToken }
        expect(response.body).to include('token')
        expect(response.body).to include('refreshToken')
      end
    end

    context 'with an invalid refresh token' do
      it 'returns an error response' do
        post :refresh_token, params: { refreshToken: 'invalid_token' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end