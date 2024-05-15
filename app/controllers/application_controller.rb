# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_internal_server_error
  # before_action :authenticate_request

  private

  def authenticate_request
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }) if token
    @current_user = User.find(decoded_token[0]['user_id']) if decoded_token
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def render_error(message, status)
    render json: { errors: message }, status:
  end

  def handle_internal_server_error(exception)
    render_error(exception.message, :internal_server_error)
  end
end
