# frozen_string_literal: true

# The model to save authentication token
class Token < ApplicationRecord
  belongs_to :user
end
