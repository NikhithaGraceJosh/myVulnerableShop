# frozen_string_literal: true

class RemoveFilterCategoryIdNotNullFromFilterCategory < ActiveRecord::Migration[6.0]
  def change
    change_column :filter_categories, :filter_category_id, :bigInt, null: true
  end
end
