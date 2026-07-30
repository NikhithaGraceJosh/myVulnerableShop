# frozen_string_literal: true

class Address < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  validates :street, presence: true
  validates :city, presence: true
  validates :zip, presence: true, numericality: true
end
