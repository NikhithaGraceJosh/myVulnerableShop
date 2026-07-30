# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :filter

  def index
    respond_to do |format|
      format.html { @products = Product.search(params[:search], params[:offset], params[:limit]) }
      format.json do
        product_html = render_to_string 'products/_product_list', layout: false, formats: [:html]
        render json: { html: product_html, success: true }
      end
    end
  end

  def show
    @product = Product.find(params[:id])
    @sizes = Size.all
    @cart_item = ShoppingCart.new
  end

  def new
    if user_signed_in?
      if current_user.admin?
        @product = Product.new
        @product_type_list = ProductType.where('id' => GenderProductType.select('product_type_id').where('gender_id' => 2))
        @product.images.build
        @product.product_sizes.build
        @existing_stock = {}
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to edit_tag_product_path(@product)
    else
      @product_type_list = ProductType.where('id' => GenderProductType.select('product_type_id').where('gender_id' => 2))
      @product.images.build
      @product.product_sizes.build
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    if user_signed_in?
      if current_user.admin?
        @product = Product.find(params[:id])
        @product_type_list = ProductType.where('id' => GenderProductType.select('product_type_id').where('gender_id' => @product.gender.id))
        @existing_stock = @product.product_sizes.where('stock_quantity > 0').pluck(:size_id, :stock_quantity).to_h
        @product.available_sizes = @existing_stock.keys
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product)
    else
      @product_type_list = ProductType.where('id' => GenderProductType.select('product_type_id').where('gender_id' => @product.gender.id))
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit_tag
    if user_signed_in?
      if current_user.admin?
        @product = Product.find(params[:id])
        @product_type = @product.product_type
        @filter_categories = @product_type.filter_categories unless @product_type.nil?
        @tag_list = @product.tag_list
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def update_tag
    @product = Product.find(params[:id])
    hash = Hash['tag_list' => params[:product].values.join(', ')]
    if @product.update(hash)
      redirect_to product_path(@product)
    else
      render 'edit_tag'
    end
  end

  def stats
    if user_signed_in?
      if current_user.admin?
        @product_ids = OrderItem.group(:product_id).order('count_product_id DESC').count(:product_id)

        @products = Product.find(@product_ids.keys)

        respond_to do |format|
          format.html
          format.csv { send_data Product.csv_data(@product_ids), filename: "products-#{Date.today}.csv" }
        end
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def reports
    if user_signed_in?
      if current_user.admin?
        render 'products/reports'
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  def report_preview
    if params[:now] == 'true'
      obj = ReportGenerateService.generate_report(params[:from], params[:to])

      respond_to do |format|
        format.json do
          @orders = obj[:orders]
          reports_html = render_to_string 'products/_report_list', layout: false, formats: [:html]

          render json: { html: reports_html, success: true, length: @orders.length }
        end
      end
    else
      ReportWorker.perform_async(params[:from], params[:to])
      respond_to do |format|
        format.json do
          render json: { html: 'Your report will be sent to your mail', success: true }
        end
      end
    end
  end

  def generate_report
    obj = ReportGenerateService.generate_report(params[:from], params[:to])

    send_data(obj[:csv], type: 'application/csv', filename: "report-#{Date.today}.csv", disposition: 'attachment')
  end

  def product_type_for_gender
    g = Gender.find(params[:gender])
    respond_to do |format|
      format.json { render json: g.product_types }
    end
  end

  def product_count
    @products = Product.joins(:gender)
                       .left_outer_joins(:product_type)
                       .search(params[:search], '100', '0')
                       .price_range(params[:min_price], params[:max_price])
                       .where(gender_filter)
                       .where(type_filter)
                       .count
  end

  # Kept as a compatibility endpoint for the collection links on the home page.
  # The filtering implementation lives in `filter`, which also serves direct
  # links from the navigation menu.
  def filter_by_gender
    redirect_to products_filter_path(
      gender: params[:gender],
      page_size: params.fetch(:page_size, 8),
      pagenum: params.fetch(:pagenum, 1)
    )
  end

  def filter
    limit = params[:page_size].to_i
    limit = 8 if limit <= 0
    offset = limit * (params[:pagenum].to_i - 1)

    @products = Product.joins(:gender)
                       .left_outer_joins(:product_type)
                       .search(params[:search], limit, offset)
                       .price_range(params[:min_price], params[:max_price])
                       .where(gender_filter)
                       .where(type_filter)
    filter_categories = []
    filter_categories = JSON.parse params[:filter_categories] unless params[:filter_categories].nil?

    unless filter_categories.empty?
      @products = @products.tagged_with(filter_categories, any: true)
    end

    @gender = params[:gender]
    @type = params[:type]
    respond_to do |format|
      format.json do
        product_html = render_to_string 'products/_product_list', layout: false, formats: [:html]
        render json: { html: product_html, success: true, total_pages: (product_count / (limit * 1.0)).ceil }
      end
      format.html do
        render 'index'
      end
    end
  end

  def get_quantity
    @ps = ProductSize.find_by(product_id: params[:product_id], size_id: params[:size_id])
    respond_to do |format|
      format.json { render json: @ps.stock_quantity }
    end
  end

  def destroy
    if user_signed_in?
      if current_user.admin?
        @product = Product.find(params[:id])
        @product.destroy

        redirect_to products_path
      else
        render '/error/unauthorised', layout: 'error_layout'
      end
    else
      flash[:error] = 'Please sign in to access this page'
      redirect_to new_user_session_path
    end
  end

  private

  def gender_filter
    return {} if params[:gender].blank?

    { genders: { name: params[:gender].to_s } }
  end

  def type_filter
    return {} if params[:type].blank?

    { product_types: { name: params[:type].to_s } }
  end

  def product_params
    product_attributes = params.require(:product).permit(:name, :details, :price, :gender_id, :product_type_id, :search, :color_list, :tag_list, available_sizes: [], product_sizes_attributes: %i[id size_id stock_quantity id], images_attributes: %i[avatar id _destroy], stock_quantity: {})

    checked_sizes = params[:product].try(:[], 'available_sizes')&.reject(&:empty?) || []

    product_sizes_attributes = checked_sizes.map.with_index do |size, i|
      product_size_id = ProductSize.find_by(product_id: params[:id].to_i, size_id: size.to_i)&.id
      [i.to_s, { "id": product_size_id, "size_id": size, "stock_quantity": params[:product].try(:[], 'stock_quantity').try(:[], (size.to_i - 1).to_s) }]
    end.to_h

    if params[:id].present?
      unchecked_product_sizes = ProductSize.where(product_id: params[:id].to_i).where.not(size_id: checked_sizes.map(&:to_i))
      unchecked_product_sizes.each_with_index do |product_size, i|
        product_sizes_attributes[(checked_sizes.length + i).to_s] = { "id": product_size.id, "size_id": product_size.size_id, "stock_quantity": 0 }
      end
    end

    product_attributes[:product_sizes_attributes] = product_sizes_attributes

    product_attributes
  end
end
