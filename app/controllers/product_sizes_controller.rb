# frozen_string_literal: true

class ProductSizesController < ApplicationController
  def destroy
    @p_s = ProductSize.find(params[:id])
    @p_s.destroy

    redirect_to product_path(@p_s.product_id)
  end
end
