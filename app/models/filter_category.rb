# frozen_string_literal: true

class FilterCategory < ApplicationRecord
  belongs_to :filter_category
  has_many :product_type_filter_categories
  has_many :product_types, through: :product_type_filter_categories
end
