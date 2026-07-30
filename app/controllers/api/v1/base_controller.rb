# frozen_string_literal: true

class Api::V1::BaseController < ActionController::API
  before_action :authenticate_sign_in

  def authenticate_sign_in
    @session = Session.find_by(token: request.headers[:token])

    if @session.nil?
      render json: { data: @user, status: 'unauthorised', include: [:user],
                     scope: @user }
      end
  end
end
