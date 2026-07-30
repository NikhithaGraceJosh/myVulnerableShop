# frozen_string_literal: true

require 'csv'
class Product < ApplicationRecord
  acts_as_paranoid
  attr_accessor :available_sizes
  attr_accessor :stock_quantity

  acts_as_taggable

  validates :name, presence: true
  validates :price, presence: true

  belongs_to :gender
  belongs_to :product_type

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :shopping_carts
  has_many :users, through: :shopping_carts

  has_many :order_items
  has_many :orders, through: :order_items

  has_many :product_sizes, dependent: :destroy
  has_many :sizes, through: :product_sizes
  accepts_nested_attributes_for :product_sizes

  validates_presence_of :images
  validates_associated :images

  def self.search(search_term, limit, offset)
    if search_term.nil? || search_term.empty?
      Product.all.offset(offset).limit(limit)
    else
      pattern = "%#{sanitize_sql_like(search_term)}%"

      includes(:images)
        .joins("LEFT JOIN taggings ON taggings.taggable_id = products.id AND taggings.taggable_type = 'Product' INNER JOIN tags ON tags.id = taggings.tag_id")
        .where("LOWER(products.name) LIKE LOWER(?) OR LOWER(tags.name) LIKE LOWER(?)", pattern, pattern)
        .distinct
    end
  end

  class << self
    def price_range(min, max)
      where(min_query(min))
        .where(max_query(max))
    end

    def min_query(min)
      return {} if min.blank?

      "price > #{min}"
    end

    def max_query(max)
      return {} if max.blank?

      "price < #{max}"
    end
  end

  def self.csv_data(product_ids)
    attributes = %w[id name details price gender #ofOrders]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      products = Product.find(product_ids.keys)
      products.each do |p|
        csv << attributes.map do |attr|
          if attr == 'gender'
            p.gender.name
          elsif attr == '#ofOrders'
            product_ids[p.id]
          else
            p.send(attr)
          end
        end
      end
    end
  end
end
