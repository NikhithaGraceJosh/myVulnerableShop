# frozen_string_literal: true

class AddMultivaluedToFilterCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :filter_categories, :multivalued, :boolean
  end
end
