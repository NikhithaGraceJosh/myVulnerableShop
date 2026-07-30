# frozen_string_literal: true

desc 'send scheduled email'
task schedule_mail_task: :environment do
  csv = ReportGenerateService.generate_report(Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)[:csv]
  OrderMailer.sales_report('nik@gmail.com', "Todays's Sales", csv).deliver
end
