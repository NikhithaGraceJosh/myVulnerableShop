# frozen_string_literal: true

require 'csv'
class Order < ApplicationRecord
  acts_as_paranoid
  belongs_to :user, -> { with_deleted }
  belongs_to :address, -> { with_deleted }

  has_many :order_items, dependent: :destroy

  has_many :products, through: :order_items
  has_many :order_statuses
  has_many :statuses, through: :order_statuses

  def self.generate_csv(orders)
    headers = ['Order ID', 'Order Date', 'Amount', 'Customer Name', 'Customer Email', 'Street', 'City', 'Zip', 'Status']
    CSV.generate(headers: true) do |csv|
      csv << headers
      orders.each do |o|
        csv << [
          o.id,
          o.order_date,
          o.amount,
          o.user&.name,
          o.user&.email,
          o.address&.street,
          o.address&.city,
          o.address&.zip,
          o.statuses.last&.name
        ]
      end
    end
  end
end
