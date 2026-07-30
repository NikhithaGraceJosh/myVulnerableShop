class CreateGenderProductTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :gender_product_types do |t|
      t.references :gender, null: false, foreign_key: true
      t.references :product_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
