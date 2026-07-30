# frozen_string_literal: true

class AddUniqueIndexToWishlists < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL.squish
      DELETE w1 FROM wishlists w1
      INNER JOIN wishlists w2
        ON w1.user_id = w2.user_id
        AND w1.product_id = w2.product_id
        AND w1.id > w2.id
    SQL

    add_index :wishlists, %i[user_id product_id], unique: true
  end

  def down
    remove_index :wishlists, %i[user_id product_id]
  end
end
