# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :details
      t.integer :price
      t.integer :stock_quantity
      t.references :category

      t.timestamps
    end
  end
end
