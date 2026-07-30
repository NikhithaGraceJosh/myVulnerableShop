# frozen_string_literal: true

class ImagesController < ApplicationController
  def create
    if params[:image][:avatar].nil?
      @user = current_user
      @user.build_image
      flash[:error] = 'Please upload your image'
      render 'user_profiles/add_user_image'
    else
      @i = Image.create(image_params)
      redirect_to user_profile_path(current_user) if @i
    end
  end

  def update
    @i = Image.find(params[:id])
    redirect_to user_profile_path(current_user) if @i.update(image_params)
  end

  private

  def image_params
    params.require(:image).permit(:avatar, :imageable_id, :imageable_type)
  end
end
