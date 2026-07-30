# frozen_string_literal: true

module OrdersHelper
  def sortable(title, column_name)
    if params[:direction] == 'asc'
      @sort_dir = 'desc'
      @arrow_img = 'sort-up'
    else
      @sort_dir = 'asc'
      @arrow_img = 'arrow-down'
    end
    link_to title, { sort: column_name, direction: @sort_dir, value: params[:value] }, class: @sort_dir
  end

  def admin_disabled_order_status(order)
    last_status_id = order.statuses.last&.id || Status.find_by(name: "Awaiting Payment").id
    arr = []
    Status.all.each do |status|
      if status.id < last_status_id
        arr << status.name
      else
        return arr
      end
    end
  end
end
