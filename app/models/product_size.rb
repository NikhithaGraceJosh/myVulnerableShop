# frozen_string_literal: true

class ProductSize < ApplicationRecord
  belongs_to :product
  belongs_to :size
  validates :product_id, uniqueness: { scope: :size_id }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
end
