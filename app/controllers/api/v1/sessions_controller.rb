# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_sign_in, only: [:create]

  def create
    @result = SessionsService.load_resource(params[:email], params[:password])
    if @result.success?
      @session = SessionsService.create_session(@result[:user])
      render json: { data: @session, status: 201, include: [:user],
                     scope: @session.user }
    else
      render json: { data: nil, status: 401, include: [:user],
                     scope: nil }
    end
  end

  def destroy
    if @session.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def create_params
    params.permit(:email, :password)
  end
end
