# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  default from: 'test123456qb@gmail.com'
  def order_email(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: 'Cherries Order')
  end

  def sales_report(email, subject, csv)
    attachments['sale_report.csv'] = { mime_type: 'text/csv', content: csv }
    mail(to: email, subject: subject)
  end
end
