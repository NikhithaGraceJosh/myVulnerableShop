class CreateFilterCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :filter_categories do |t|
      t.string :name
      t.references :filter_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
