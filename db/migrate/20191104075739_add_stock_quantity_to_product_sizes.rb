class AddStockQuantityToProductSizes < ActiveRecord::Migration[6.0]
  def change
    add_column :product_sizes, :stock_quantity, :integer
  end
end
