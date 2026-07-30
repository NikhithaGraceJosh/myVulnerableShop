# frozen_string_literal: true

class CreateOrderStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :order_statuses do |t|
      t.references :order
      t.references :status

      t.timestamps
    end
  end
end
