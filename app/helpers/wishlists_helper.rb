# frozen_string_literal: true

module WishlistsHelper
  def wishlisted(product)
    item = Wishlist.find_by(user_id: current_user.id, product_id: product.id)
    if item.nil?
      false
    else
      true
    end
  end
end
