# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    refreshToken { SecureRandom.hex(10) }
    expiredAt { Time.current + 30.days }
    user
  end
end
