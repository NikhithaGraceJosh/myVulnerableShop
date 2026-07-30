# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-warning'
    end
  end

  def genders
    Gender.all
  end

  def filter_categories
    if params[:search].blank?
      if params[:type].blank?
        if params[:gender].blank?
          return FilterCategory.where(filter_category_id: nil)
        else
          gender = Gender.find_by(name: params[:gender])
          return FilterCategory.none unless gender

          @product_types = gender.product_types
          return FilterCategory.find(@product_types.map(&:filter_category_ids).uniq)
        end
      end
      @product_type = ProductType.find_by(name: params[:type])
      return FilterCategory.none unless @product_type

      @product_type.filter_categories
    else
      FilterCategory.where(filter_category_id: nil)
    end
  end
end
