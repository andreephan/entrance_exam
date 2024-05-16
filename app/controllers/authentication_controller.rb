# frozen_string_literal: true

# Controller for authentication
class AuthenticationController < ApplicationController
  before_action :authenticate_request, only: [:sign_out]

  def sign_up
    user = User.new(user_params)
    if user.save
      render json: user_response(user), status: :created
    else
      render_error(user.errors.full_messages, :bad_request)
    end
  end

  def sign_in
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token, refresh_token = generate_tokens(user)
      user.tokens.create!(refreshToken: refresh_token, expiredAt: Time.current + 30.days)
      render json: token_response(user, token, refresh_token), status: :ok
    else
      render_error('Invalid email or password', :unauthorized)
    end
  end

  def sign_out
    @current_user.tokens.destroy_all
    head :no_content
  end

  def refresh_token
    token = Token.find_by(refreshToken: params[:refreshToken])
    if token.present? && token.expiredAt > Time.current
      new_token, refresh_token = generate_tokens(token.user)
      token.update!(refreshToken: refresh_token, expiredAt: Time.current + 30.days)
      render json: { token: new_token, refreshToken: refresh_token }, status: :ok
    else
      render_error('Invalid refresh token', :not_found)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :firstName, :lastName)
  end

  def token_response(user, token, refresh_token)
    {
      user: user_response(user),
      token:,
      refreshToken: refresh_token
    }
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      displayName: user.display_name
    }
  end

  def generate_tokens(user)
    payload = { user_id: user.id }
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256', { exp: 1.hour.from_now.to_i })
    refresh_token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256',
                               { exp: 30.days.from_now.to_i })
    [token, refresh_token]
  end
end
