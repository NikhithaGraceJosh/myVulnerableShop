# frozen_string_literal: true

class AddTokenToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :token, :string
  end

  def down
    remove_column :users, :token, :string
  end
end
