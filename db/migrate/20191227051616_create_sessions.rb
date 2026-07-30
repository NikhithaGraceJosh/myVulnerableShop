# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.references :user
      t.string :token
    end
  end
end
