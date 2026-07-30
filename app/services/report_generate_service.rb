# frozen_string_literal: true

class ReportGenerateService
  def self.generate_report(from, to)
    from_time = from.present? ? from.to_time.beginning_of_day : nil
    to_time = to.present? ? to.to_time.end_of_day : nil
    @orders = Order.where(created_at: from_time..to_time)
    csv = Order.generate_csv(@orders)
    { "orders": @orders, "csv": csv }
  end
end
