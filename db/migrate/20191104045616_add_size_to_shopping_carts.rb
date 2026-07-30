# frozen_string_literal: true

class AddSizeToShoppingCarts < ActiveRecord::Migration[6.0]
  def change
    add_reference :shopping_carts, :size, index: true
  end
end
