# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :refreshToken
      t.datetime :expiredAt
      t.timestamps
    end
  end
end
