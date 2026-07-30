# frozen_string_literal: true

class ReportWorker
  include Sidekiq::Worker

  def perform(from, to)
    csv = ReportGenerateService.generate_report(from, to)[:csv]
    OrderMailer.sales_report('nik@gmail.com', "Sales from #{from} to #{to}", csv).deliver
  end
end
