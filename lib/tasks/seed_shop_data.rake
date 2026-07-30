# Populates myVulnerableShop with realistic products and supporting data (genders,
# product types, sizes, filter categories, sample customers/orders) so the app has
# enough content to actually practice against. Safe to run multiple times -
# everything is looked up before it's created, so re-running won't duplicate records.
#
# Each product lists the exact image filenames expected in db/seed_images/ (created
# automatically on first run). Files already dropped in there get attached; anything
# still missing is printed at the end so you know what to add before re-running.
#
#   bin/rails shop:populate
#
namespace :shop do
  desc 'Populate the vulnerable shop with products, taxonomy, sample customers and orders'
  task populate: :environment do
    ShopDataSeeder.new.run
  end
end

class ShopDataSeeder
  SEED_IMAGES_DIR = Rails.root.join('db', 'seed_images')

  CUSTOMERS = [
    { name: 'Lukas Becker', email: 'lukas.becker@example.com', phone: '4915123456',
      address: { street: 'Alexanderplatz 5', city: 'Berlin', zip: '10178' } },
    { name: 'Camille Dubois', email: 'camille.dubois@example.com', phone: '3312345678',
      address: { street: 'Rue de Rivoli 12', city: 'Paris', zip: '75001' } },
    { name: 'Giulia Ricci', email: 'giulia.ricci@example.com', phone: '3934567890',
      address: { street: 'Via Torino 8', city: 'Milan', zip: '20123' } },
    { name: 'Marta Garcia', email: 'marta.garcia@example.com', phone: '3412345678',
      address: { street: 'Calle Gran Via 20', city: 'Madrid', zip: '28013' } }
  ].freeze

  # Names and creation order matter here: OrdersController/PaymentsController look up
  # "Awaiting Payment" / "Awaiting Fulfillment" by name, and the order-status UI treats
  # a higher status id as "further along" in the flow.
  STATUS_NAMES = ['Awaiting Payment', 'Awaiting Fulfillment', 'Shipped', 'Delivered', 'Cancelled'].freeze

  # Order matters: existing controller/view code defaults new-product forms to gender_id 2 (Women).
  GENDER_NAMES = %w[Men Women].freeze

  PRODUCT_TYPE_NAMES = ['T-Shirts', 'Shirts', 'Trousers', 'Dresses', 'Skirts'].freeze

  GENDER_PRODUCT_TYPES = {
    'Men' => ['T-Shirts', 'Shirts', 'Trousers'],
    'Women' => ['Shirts', 'Dresses', 'Skirts']
  }.freeze

  SIZE_NAMES = %w[S M L XL XXL].freeze

  FILTER_CATEGORIES = {
    'Color' => %w[Black White Red Blue Green Grey Beige Brown Navy Pink Yellow],
    'Brand' => ['Nike', 'Adidas', 'Zara', 'H&M', "Levi's", 'Mango', 'Tommy Hilfiger', 'Uniqlo'],
    'Material' => %w[Cotton Polyester]
  }.freeze

  # `images` lists the exact filenames (as saved in db/seed_images/) for each product, in
  # the order they should appear on the product page.
  PRODUCTS = [
    { name: "Adidas Men's Black Print Tee", gender: 'Men', type: 'T-Shirts',
      details: 'Cotton tee with a bold graphic print on the front.',
      price: 28, tags: %w[Adidas Black Cotton],
      sizes: { 'S' => 20, 'M' => 30, 'L' => 25, 'XL' => 15 },
      images: ['men black print tshirt 1.png', 'men black print tshirt 2.png', 'men black print tshirt 3.png'] },
    { name: "Nike Men's Green Tee", gender: 'Men', type: 'T-Shirts',
      details: 'Soft cotton tee in a fresh green colourway.',
      price: 27, tags: %w[Nike Green Cotton],
      sizes: { 'S' => 20, 'M' => 28, 'L' => 22, 'XL' => 12 },
      images: ['men green tshirt 1.png', 'men green tshirt 2.png', 'men green tshirt 3.png'] },

    { name: "Tommy Hilfiger Men's Green Shirt", gender: 'Men', type: 'Shirts',
      details: 'Tailored cotton shirt in a rich green shade.',
      price: 65, tags: ['Tommy Hilfiger', 'Green', 'Cotton'],
      sizes: { 'S' => 12, 'M' => 18, 'L' => 16, 'XL' => 10 },
      images: ['men green shirt 1.png', 'men green shirt 2.png', 'men green shirt 3.png'] },
    { name: "Zara Men's Red Check Shirt", gender: 'Men', type: 'Shirts',
      details: 'Classic check shirt in cotton, cut for a regular fit.',
      price: 55, tags: %w[Zara Red Cotton],
      sizes: { 'S' => 10, 'M' => 16, 'L' => 14, 'XL' => 8 },
      images: ['men red check shirt 1.png', 'men red check shirt 2.png', 'men red check shirt 3.png'] },
    { name: "H&M Women's Green Casual Shirt", gender: 'Women', type: 'Shirts',
      details: 'Relaxed cotton shirt for everyday wear.',
      price: 40, tags: ["H&M", 'Green', 'Cotton'],
      sizes: { 'S' => 16, 'M' => 20, 'L' => 12 },
      images: ['women green casual shirt 1.png', 'women green casual shirt 2.png', 'women green casual shirt 3.png'] },
    { name: "Mango Women's White Formal Top", gender: 'Women', type: 'Shirts',
      details: 'Crisp white top tailored for the office.',
      price: 48, tags: %w[Mango White Polyester],
      sizes: { 'S' => 14, 'M' => 18, 'L' => 12 },
      images: ['women white formal top 1.png', 'women white formal top 2.png', 'women white formal top 3.png'] },
    { name: "Zara Women's White Top", gender: 'Women', type: 'Shirts',
      details: 'Lightweight white top with a relaxed everyday fit.',
      price: 30, tags: %w[Zara White Cotton],
      sizes: { 'S' => 18, 'M' => 22, 'L' => 14 },
      images: ['women white top 1.png', 'women white top 2.png', 'women white top 3.png'] },

    { name: "Levi's Men's Blue Chinos", gender: 'Men', type: 'Trousers',
      details: 'Cotton chinos in classic blue, tailored for a straight fit.',
      price: 75, tags: ["Levi's", 'Blue', 'Cotton'],
      sizes: { 'S' => 12, 'M' => 20, 'L' => 18, 'XL' => 10 },
      images: ['men blue pants 1.png', 'men blue pants 2.png', 'men blue pants 3.png'] },
    { name: "Levi's Men's Green Cargo Pants", gender: 'Men', type: 'Trousers',
      details: 'Utility-inspired cargo pants in cotton twill.',
      price: 80, tags: ["Levi's", 'Green', 'Cotton'],
      sizes: { 'S' => 10, 'M' => 18, 'L' => 16, 'XL' => 8 },
      images: ['men green pants 1.png', 'men green pants 2.png', 'men green pants 3.png'] },

    { name: 'H&M Black Slip Dress', gender: 'Women', type: 'Dresses',
      details: 'Minimalist slip dress in black satin-finish polyester.',
      price: 60, tags: ["H&M", 'Black', 'Polyester'],
      sizes: { 'S' => 12, 'M' => 16, 'L' => 10 },
      images: ['black dress 1.png', 'black dress 2.png'] },
    { name: 'Zara Blue Wrap Dress', gender: 'Women', type: 'Dresses',
      details: 'Cotton wrap dress in blue with a flattering tie waist.',
      price: 70, tags: %w[Zara Blue Cotton],
      sizes: { 'S' => 12, 'M' => 16, 'L' => 10 },
      images: ['blue dress type A 1.png', 'blue dress type A 2.png', 'blue dress type A 3.png'] },
    { name: 'Mango Pink Midi Dress', gender: 'Women', type: 'Dresses',
      details: 'Midi-length dress in soft pink cotton.',
      price: 68, tags: %w[Mango Pink Cotton],
      sizes: { 'S' => 10, 'M' => 14, 'L' => 8 },
      images: ['pink dress type A 1.png', 'pink dress type A 2.png', 'pink dress type A 3.png'] },

    { name: 'Zara Black Mini Skirt', gender: 'Women', type: 'Skirts',
      details: 'Fitted mini skirt in stretch cotton.',
      price: 35, tags: %w[Zara Black Cotton],
      sizes: { 'S' => 14, 'M' => 18, 'L' => 12 },
      images: ['black skirt 1.png', 'black skirt 2.png', 'black skirt 3.png'] },
    { name: 'Zara Blue A-Line Skirt', gender: 'Women', type: 'Skirts',
      details: 'A-line skirt in cotton with a flattering silhouette.',
      price: 38, tags: %w[Zara Blue Cotton],
      sizes: { 'S' => 12, 'M' => 16, 'L' => 10 },
      images: ['blue skirt 1.png', 'blue skirt 2.png', 'blue skirt 3.png'] },
    { name: 'Mango Yellow Pleated Skirt', gender: 'Women', type: 'Skirts',
      details: 'Pleated skirt in a bright yellow polyester blend.',
      price: 42, tags: %w[Mango Yellow Polyester],
      sizes: { 'S' => 10, 'M' => 14, 'L' => 8 },
      images: ['yellow skirt 1.png', 'yellow skirt 2.png', 'yellow skirt 3.png'] }
  ].freeze

  def run
    FileUtils.mkdir_p(SEED_IMAGES_DIR)
    @missing_images = []

    seed_roles_and_admin
    @customers_by_email = seed_customers
    seed_statuses
    seed_genders
    seed_product_types
    seed_sizes
    seed_filter_categories
    seed_products
    remove_products_not_in_catalog
    cleanup_legacy_genders
    cleanup_legacy_sizes
    cleanup_legacy_product_types
    seed_sample_orders

    print_summary
  end

  private

  def seed_roles_and_admin
    puts 'Seeding roles and admin user...'
    admin_role = Role.find_or_create_by!(name: 'admin')
    Role.find_or_create_by!(name: 'user')

    admin_user = User.find_or_create_by!(email: 'admin@domain.com') do |u|
      u.name = 'admin'
      u.password = 'password'
    end
    admin_user.roles = [admin_role] unless admin_user.roles.include?(admin_role)
  end

  def seed_customers
    puts 'Seeding sample customers...'
    CUSTOMERS.each_with_object({}) do |data, hash|
      user = User.find_or_create_by!(email: data[:email]) do |u|
        u.name = data[:name]
        u.phone = data[:phone]
        u.password = 'password'
      end
      user.addresses.find_or_create_by!(street: data[:address][:street]) do |a|
        a.city = data[:address][:city]
        a.zip = data[:address][:zip]
      end
      hash[data[:email]] = user
    end
  end

  def seed_statuses
    puts 'Seeding order statuses...'
    STATUS_NAMES.each { |name| Status.find_or_create_by!(name: name) }
  end

  def seed_genders
    puts 'Seeding genders...'
    GENDER_NAMES.each { |name| Gender.find_or_create_by!(name: name) }
    @genders_by_name = Gender.all.index_by(&:name)
  end

  def seed_product_types
    puts 'Seeding product types...'
    PRODUCT_TYPE_NAMES.each { |name| ProductType.find_or_create_by!(name: name) }
    @product_types_by_name = ProductType.all.index_by(&:name)

    GENDER_PRODUCT_TYPES.each do |gender_name, type_names|
      type_names.each do |type_name|
        GenderProductType.find_or_create_by!(
          gender: @genders_by_name.fetch(gender_name),
          product_type: @product_types_by_name.fetch(type_name)
        )
      end
    end
  end

  def seed_sizes
    puts 'Seeding sizes...'
    SIZE_NAMES.each { |name| Size.find_or_create_by!(name: name) }
    @sizes_by_name = Size.all.index_by(&:name)
  end

  def seed_filter_categories
    puts 'Seeding filter categories...'
    @filter_categories_by_name = {}

    FILTER_CATEGORIES.each_key do |top_name|
      top = FilterCategory.find_by(name: top_name, filter_category_id: nil)
      if top.nil?
        top = FilterCategory.new(name: top_name, filter_category_id: nil, multivalued: true)
        # belongs_to :filter_category has no `optional: true`, so root nodes fail
        # the normal presence validation - this mirrors how the app already
        # tolerates nullable filter_category_id at the DB level.
        top.save!(validate: false)
      end
      @filter_categories_by_name[top_name] = top
    end

    FILTER_CATEGORIES.each do |top_name, children|
      top = @filter_categories_by_name.fetch(top_name)
      children.each do |child_name|
        FilterCategory.find_or_create_by!(name: child_name, filter_category_id: top.id)
      end
    end

    PRODUCT_TYPE_NAMES.each do |type_name|
      FILTER_CATEGORIES.each_key do |top_name|
        ProductTypeFilterCategory.find_or_create_by!(
          product_type: @product_types_by_name.fetch(type_name),
          filter_category: @filter_categories_by_name.fetch(top_name)
        )
      end
    end
  end

  def seed_products
    puts 'Seeding products...'

    PRODUCTS.each do |data|
      first_image = data[:images].first

      product = Product.find_or_create_by!(name: data[:name]) do |p|
        p.details = data[:details]
        p.price = data[:price]
        p.gender = @genders_by_name.fetch(data[:gender])
        p.product_type = @product_types_by_name.fetch(data[:type])
        p.images.build(name: first_image)
      end

      current_attrs = {
        details: data[:details],
        price: data[:price],
        gender: @genders_by_name.fetch(data[:gender]),
        product_type: @product_types_by_name.fetch(data[:type])
      }
      changed_attrs = current_attrs.select { |attr, value| product.public_send(attr) != value }
      product.update!(changed_attrs) if changed_attrs.any?

      product.update!(tag_list: data[:tags]) if product.tag_list.sort != data[:tags].sort

      data[:sizes].each do |size_name, stock|
        product.product_sizes.find_or_create_by!(size: @sizes_by_name.fetch(size_name)) do |ps|
          ps.stock_quantity = stock
        end
      end

      data[:images].each do |filename|
        image = product.images.find_or_create_by!(name: filename)
        @missing_images << filename if %i[missing failed].include?(attach_seed_image(image, filename))
      end
    end
  end

  # Runs after seed_products: any product that isn't in the current PRODUCTS list is a
  # leftover from an earlier catalog (e.g. renamed or removed product types), so it's
  # hard-deleted rather than left soft-deleted, which would keep blocking foreign keys
  # on genders/product_types below.
  def remove_products_not_in_catalog
    keep_names = PRODUCTS.map { |data| data[:name] }
    Product.where.not(name: keep_names).find_each do |product|
      puts "Removing product no longer in the catalog: #{product.name}"
      product.really_destroy!
    end
  end

  # Runs after remove_products_not_in_catalog, once no product row (live or otherwise)
  # still points at a gender outside GENDER_NAMES, so the products.gender_id foreign key
  # is safe to drop.
  def cleanup_legacy_genders
    Gender.where.not(name: GENDER_NAMES).find_each do |gender|
      puts "Removing unused gender: #{gender.name}"
      GenderProductType.where(gender: gender).destroy_all
      gender.destroy!
    end
  end

  def cleanup_legacy_sizes
    Size.where.not(name: SIZE_NAMES).find_each do |size|
      next if size.product_sizes.exists?

      puts "Removing unused size: #{size.name}"
      size.destroy!
    end
  end

  # Runs after remove_products_not_in_catalog, once no product row still points at a
  # product type outside PRODUCT_TYPE_NAMES, so the products.product_type_id foreign key
  # is safe to drop.
  def cleanup_legacy_product_types
    ProductType.where.not(name: PRODUCT_TYPE_NAMES).find_each do |type|
      puts "Removing unused product type: #{type.name}"
      GenderProductType.where(product_type: type).destroy_all
      ProductTypeFilterCategory.where(product_type: type).destroy_all
      type.destroy!
    end
  end

  def attach_seed_image(image, filename)
    return :already_attached if image.avatar.attached?

    path = SEED_IMAGES_DIR.join(filename)
    return :missing unless File.exist?(path)

    image.avatar.attach(io: File.open(path), filename: filename)
    :attached
  rescue StandardError => e
    puts "  ! Could not attach #{filename}: #{e.message}"
    :failed
  end

  def seed_sample_orders
    puts 'Seeding sample orders...'
    lukas = @customers_by_email.fetch('lukas.becker@example.com')
    camille = @customers_by_email.fetch('camille.dubois@example.com')

    if Order.where(user: lukas).none?
      create_order(
        lukas, lukas.addresses.first,
        [["Levi's Men's Blue Chinos", 'L', 1]],
        ['Awaiting Payment', 'Awaiting Fulfillment', 'Shipped']
      )
      create_order(
        lukas, lukas.addresses.first,
        [["Adidas Men's Black Print Tee", 'M', 2], ["Tommy Hilfiger Men's Green Shirt", 'L', 1]],
        ['Awaiting Payment']
      )
    end

    return unless Order.where(user: camille).none?

    create_order(
      camille, camille.addresses.first,
      [['Zara Blue Wrap Dress', 'M', 1]],
      ['Awaiting Payment', 'Awaiting Fulfillment', 'Shipped', 'Delivered']
    )
  end

  def create_order(user, address, items, status_sequence)
    order = Order.new(user: user, address: address, order_date: Time.current)
    order_items = items.map do |product_name, size_name, quantity|
      product = Product.find_by!(name: product_name)
      size = Size.find_by!(name: size_name)
      OrderItem.new(product: product, size: size, quantity: quantity)
    end
    order.amount = order_items.sum { |oi| oi.product.price * oi.quantity }
    order.order_items = order_items
    order.save!

    status_sequence.each do |status_name|
      OrderStatus.create!(order: order, status: Status.find_by!(name: status_name))
    end
    order
  end

  def print_summary
    puts "\nDone. #{Product.count} products, #{User.count} users, #{Order.count} orders seeded."

    return unless @missing_images.any?

    puts "\n#{@missing_images.size} product photo(s) are not attached yet."
    puts "Add these files to #{SEED_IMAGES_DIR} using the exact names below, then run `bin/rails shop:populate` again:\n\n"
    @missing_images.each { |f| puts "  - #{f}" }
  end
end
