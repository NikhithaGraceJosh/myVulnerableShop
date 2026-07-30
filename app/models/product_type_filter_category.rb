class ProductTypeFilterCategory < ApplicationRecord
  belongs_to :product_type
  belongs_to :filter_category
end
