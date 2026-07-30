# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Importmap modules are individually requested by the browser, so each local
# module must be available in the production asset manifest.
Rails.application.config.assets.precompile += %w[
  add-to-wishlist.js address-cart.js application.js filters.js footer.js
  index.js lazyload.js multiple-select.js place-order.js product-type.js
  product_size_button.js quantity_per_size.js report_preview.js
  stripe_payment.js update_cart.js update_order_status.js user_image_upload.js
  cocoon.js turbo.min.js activestorage.esm.js
  devise.css sessions.css header.css error.css
]
