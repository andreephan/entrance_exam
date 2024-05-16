# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    firstName { Faker::Name.first_name }
    lastName { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
