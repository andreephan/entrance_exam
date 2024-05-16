require 'swagger_helper'

RSpec.describe 'api/authentication', type: :request do
  path '/sign-up' do
    post 'Creates a user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          firstName: { type: :string },
          lastName: { type: :string },
          password: { type: :string }
        },
        required: %w[email firstName lastName password]
      }

      response '201', 'user created' do
        run_test!
      end

      response '400', 'invalid request' do
        run_test!
      end

      response '500', 'internal error' do
        run_test!
      end
    end
  end

  path '/sign-in' do
    post 'Login' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          firstName: { type: :string }
        },
        required: %w[email firstName]
      }

      response '200', 'login successful' do
        run_test!
      end

      response '400', 'invalid request' do
        run_test!
      end

      response '500', 'internal error' do
        run_test!
      end
    end
  end

  path '/sign-out' do
    post 'Sign Out' do
      tags 'Authentication'
      consumes 'application/json'
      response '204', 'logout successful' do
        run_test!
      end

      response '500', 'internal error' do
        run_test!
      end
    end
  end

  path '/refresh-token' do
    post 'Refresh token' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          refreshToken: { type: :string }
        },
        required: %w[refreshToken]
      }

      response '200', 'refresh token successful' do
        run_test!
      end

      response '404', 'token not found' do
        run_test!
      end

      response '500', 'internal error' do
        run_test!
      end
    end
  end
end
