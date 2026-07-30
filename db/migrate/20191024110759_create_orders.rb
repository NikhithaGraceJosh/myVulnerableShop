# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :address
      t.timestamp :order_date
      t.integer :amount

      t.timestamps
    end
  end
end
