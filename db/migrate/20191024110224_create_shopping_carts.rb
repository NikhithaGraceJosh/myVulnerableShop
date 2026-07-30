# frozen_string_literal: true

class CreateShoppingCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_carts do |t|
      t.references :user
      t.references :product
      t.integer :quantity

      t.timestamps
    end
  end
end
