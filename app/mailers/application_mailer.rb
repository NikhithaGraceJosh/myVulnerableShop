# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'test123456qb@gmail.com'
  layout 'mailer'
end
