# frozen_string_literal: true

class Gender < ApplicationRecord
  has_many :gender_product_types
  has_many :product_types, through: :gender_product_types
end
