# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 8..20 }
  validates :firstName, presence: true
  validates :lastName, presence: true

  has_many :tokens, dependent: :destroy

  def displayName
    "#{firstName} #{lastName}"
  end
end