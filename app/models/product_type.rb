# frozen_string_literal: true

class ProductType < ApplicationRecord
  has_many :gender_product_types
  has_many :genders, through: :gender_product_types

  has_many :product_type_filter_categories
  has_many :filter_categories, through: :product_type_filter_categories

  has_many :products
end
