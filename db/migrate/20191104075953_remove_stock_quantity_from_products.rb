class RemoveStockQuantityFromProducts < ActiveRecord::Migration[6.0]
  def change

    remove_column :products, :stock_quantity, :integer
  end
end
