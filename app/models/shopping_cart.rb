# frozen_string_literal: true

class ShoppingCart < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :size
  validate :quantity_less_than_stock
  validate :quantity_less_than_5
  def quantity_less_than_stock
    return {} if size_id.blank?

    ps = ProductSize.find_by(product_id: product_id, size_id: size_id)
    if ps.nil?
      errors.add(:size, 'Size not available')
    else
      if ps.stock_quantity == 0
        errors.add(:quantity, 'Out Of Stock!')
      else
        if quantity > ps.stock_quantity
          errors.add(:quantity, "Not enough stock. Only #{ps.stock_quantity} left")
        end
      end
    end
  end

  def quantity_less_than_5
    errors.add(:quantity, "Sorry. Can't purchase more than 5 of the same product") if quantity > 5
  end
end
