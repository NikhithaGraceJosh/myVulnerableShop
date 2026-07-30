class CreateProductTypeFilterCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :product_type_filter_categories do |t|
      t.references :product_type, null: false, foreign_key: true
      t.references :filter_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
