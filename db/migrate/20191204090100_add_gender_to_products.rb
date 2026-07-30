# frozen_string_literal: true

class AddGenderToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :gender, null: true, foreign_key: true
  end
end
