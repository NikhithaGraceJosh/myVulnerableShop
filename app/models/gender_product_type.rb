class GenderProductType < ApplicationRecord
  belongs_to :gender
  belongs_to :product_type
end
