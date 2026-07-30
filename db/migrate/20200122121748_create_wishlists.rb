# frozen_string_literal: true

class CreateWishlists < ActiveRecord::Migration[6.0]
  def change
    create_table :wishlists do |t|
      t.references :product
      t.references :user
      t.timestamps
    end
  end
end
