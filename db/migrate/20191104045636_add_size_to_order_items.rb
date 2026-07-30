# frozen_string_literal: true

class AddSizeToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_items, :size, index: true
  end
end
