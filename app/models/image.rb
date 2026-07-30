# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :avatar
end
