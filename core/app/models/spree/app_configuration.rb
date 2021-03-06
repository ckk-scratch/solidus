# This is the primary location for defining spree preferences
#
# The expectation is that this is created once and stored in
# the spree environment
#
# setters:
# a.color = :blue
# a[:color] = :blue
# a.set :color = :blue
# a.preferred_color = :blue
#
# getters:
# a.color
# a[:color]
# a.get :color
# a.preferred_color
#
require "spree/core/search/base"
require "spree/core/search/variant"

module Spree
  class AppConfiguration < Preferences::Configuration
    # Alphabetized to more easily lookup particular preferences

    # @!attribute [rw] address_requires_state
    #   @return [Boolean] should state/state_name be required
    preference :address_requires_state, :boolean, default: true

    # @!attribute [rw] admin_interface_logo
    #   @return [String] URL of logo used in admin (default: +'logo/solidus_logo.png'+)
    preference :admin_interface_logo, :string, default: 'logo/solidus_logo.png'

    # @!attribute [rw] admin_products_per_page
    #   @return [Integer] Number of products to display in admin (default: +10+)
    preference :admin_products_per_page, :integer, default: 10

    # @!attribute [rw] admin_variants_per_page
    #   @return [Integer] Number of variants to display in admin (default: +20+)
    preference :admin_variants_per_page, :integer, default: 20

    # @!attribute [rw] allow_checkout_on_gateway_error
    #   @return [Boolean] Allow checkout to complete after a failed payment (default: +false+)
    preference :allow_checkout_on_gateway_error, :boolean, default: false

    # @!attribute [rw] allow_guest_checkout
    #   @return [Boolean] When false, customers must create an account to complete an order (default: +true+)
    preference :allow_guest_checkout, :boolean, default: true

    # @!attribute [rw] allow_return_item_amount_editing
    #   @return [Boolean] Determines whether an admin is allowed to change a return item's pre-calculated amount (default: +false+)
    preference :allow_return_item_amount_editing, :boolean, default: false

    # @!attribute [rw] alternative_billing_phone
    #   @return [Boolean] Request an extra phone number for bill address (default: +false+)
    preference :alternative_billing_phone, :boolean, default: false

    # @!attribute [rw] alternative_shipping_phone
    #   @return [Boolean] Request an extra phone number for shipping address (default: +false+)
    preference :alternative_shipping_phone, :boolean, default: false

    # @!attribute [rw] always_put_site_name_in_title
    #   @return [Boolean] When true, site name is always appended to titles on the frontend (default: +true+)
    preference :always_put_site_name_in_title, :boolean, default: true

    # @!attribute [rw] auto_capture
    #   @note Setting this to true is not recommended. Performing an authorize
    #     and later capture has far superior error handing. VISA and MasterCard
    #     also require that shipments are sent within a certain time of the card
    #     being charged.
    #   @return [Boolean] Perform a sale/purchase transaction at checkout instead of a authorize and capture.
    preference :auto_capture, :boolean, default: false

    # @!attribute [rw] auto_capture_exchanges
    # @return [Boolean] automatically capture the credit card (as opposed to just authorize and capture later) (default: +false+)
    preference :auto_capture_exchanges, :boolean, default: false

    # @!attribute [rw] binary_inventory_cache
    #   Only invalidate product caches when they change from in stock to out of
    #   stock. By default, caches are invalidated on any change of inventory
    #   quantity. Setting this to true should make operations on inventory
    #   faster.
    #   (default: +false+)
    #   @return [Boolean]
    preference :binary_inventory_cache, :boolean, default: false

    # @!attribute [rw] checkout_zone
    #   @return [String] Name of a {Zone}, which limits available countries to those included in that zone. (default: +nil+)
    preference :checkout_zone, :string, default: nil

    # @!attribute [rw] company
    #   @return [Boolean] Request company field for billing and shipping addresses. (default: +false+)
    preference :company, :boolean, default: false

    # @!attribute [rw] create_rma_for_unreturned_exchange
    #   @return [Boolean] allows rma to be created for items after unreturned exchange charge has been made (default: +false+)
    preference :create_rma_for_unreturned_exchange, :boolean, default: false

    # @!attribute [rw] currency
    #   Currency to use by default when not defined on the site (default: +"USD"+)
    #   @return [String] ISO 4217 Three letter currency code
    preference :currency, :string, default: "USD"

    # @!attribute [rw] default_country_id
    #   @deprecated
    #   @return [Integer,nil] id of {Country} to be selected by default in dropdowns (default: nil)
    preference :default_country_id, :integer

    # @!attribute [rw] expedited_exchanges
    #   Kicks off an exchange shipment upon return authorization save.
    #   charge customer if they do not return items within timely manner.
    #   @note this requires payment profiles to be supported on your gateway of
    #     choice as well as a delayed job handler to be configured with
    #     activejob.
    #   @return [Boolean] Use expidited exchanges (default: +false+)
    preference :expedited_exchanges, :boolean, default: false

    # @!attribute [rw] expedited_exchanges_days_window
    #   @return [Integer] Number of days the customer has to return their item
    #     after the expedited exchange is shipped in order to avoid being
    #     charged (default: +14+)
    preference :expedited_exchanges_days_window, :integer, default: 14

    # @!attribute [rw] layout
    #   @return [String] template to use for layout on the frontend (default: +"spree/layouts/spree_application"+)
    preference :layout, :string, default: 'spree/layouts/spree_application'

    # @!attribute [rw] logo
    #   @return [String] URL of logo used on frontend (default: +'logo/solidus_logo.png'+)
    preference :logo, :string, default: 'logo/solidus_logo.png'

    # @!attribute [rw] order_capturing_time_window
    #   @return [Integer] the number of days to look back for fully-shipped/cancelled orders in order to charge for them
    preference :order_capturing_time_window, :integer, default: 14

    # @!attribute [rw] max_level_in_taxons_menu
    #   @return [Integer] maximum nesting level in taxons menu (default: +1+)
    preference :max_level_in_taxons_menu, :integer, default: 1

    # @!attribute [rw] order_mutex_max_age
    #   @return [Integer] Max age of {OrderMutex} in seconds (default: 2 minutes)
    preference :order_mutex_max_age, :integer, default: 120

    # @!attribute [rw] orders_per_page
    #   @return [Integer] Orders to show per-page in the admin (default: +15+)
    preference :orders_per_page, :integer, default: 15

    # @!attribute [rw] properties_per_page
    #   @return [Integer] Properties to show per-page in the admin (default: +15+)
    preference :properties_per_page, :integer, default: 15

    # @!attribute [rw] products_per_page
    #   @return [Integer] Products to show per-page in the frontend (default: +12+)
    preference :products_per_page, :integer, default: 12

    # @!attribute [rw] promotions_per_page
    #   @return [Integer] Promotions to show per-page in the admin (default: +15+)
    preference :promotions_per_page, :integer, default: 15

    # @!attribute [rw] customer_returns_per_page
    #   @return [Integer] Customer returns to show per-page in the admin (default: +15+)
    preference :customer_returns_per_page, :integer, default: 15

    # @!attribute [rw] require_master_price
    #   @return [Boolean] Require a price on the master variant of a product (default: +true+)
    preference :require_master_price, :boolean, default: true

    # @!attribute [rw] require_payment_to_ship
    #   @return [Boolean] Allows shipments to be ready to ship regardless of the order being paid if false (default: +true+)
    preference :require_payment_to_ship, :boolean, default: true # Allows shipments to be ready to ship regardless of the order being paid if false

    # @!attribute [rw] return_eligibility_number_of_days
    #   @return [Integer] default: 365
    preference :return_eligibility_number_of_days, :integer, default: 365

    # @!attribute [rw] shipping_instructions
    #   @return [Boolean] Request instructions/info for shipping (default: +false+)
    preference :shipping_instructions, :boolean, default: false

    # @!attribute [rw] show_only_complete_orders_by_default
    #   @return [Boolean] Only show completed orders by default in the admin (default: +true+)
    preference :show_only_complete_orders_by_default, :boolean, default: true

    # @!attribute [rw] show_variant_full_price
    #   @return [Boolean] Displays variant full price or difference with product price. (default: +false+)
    preference :show_variant_full_price, :boolean, default: false

    # @!attribute [rw] show_products_without_price
    #   @return [Boolean] Whether products without a price are visible in the frontend (default: +false+)
    preference :show_products_without_price, :boolean, default: false

    # @!attribute [rw] show_raw_product_description
    #   @return [Boolean] Don't escape HTML of product descriptions. (default: +false+)
    preference :show_raw_product_description, :boolean, :default => false

    # @!attribute [rw] tax_using_ship_address
    #   @return [Boolean] Use the shipping address rather than the billing address to determine tax (default: +true+)
    preference :tax_using_ship_address, :boolean, default: true

    # @!attribute [rw] track_inventory_levels
    #   Determines whether to track on_hand values for variants / products. If
    #   you do not track inventory, or have effectively unlimited inventory for
    #   all products you can turn this on.
    #   @return [] Track on_hand values for variants / products. (default: true)
    preference :track_inventory_levels, :boolean, default: true

    # Default mail headers settings

    # @!attribute [rw] send_core_emails
    #   @return [Boolean] Whether to send transactional emails (default: true)
    preference :send_core_emails, :boolean, default: true

    # @!attribute [rw] mails_from
    #   @return [String] Email address used as +From:+ field in transactional emails.
    preference :mails_from, :string, :default => 'spree@example.com'

    # Store credits configurations

    # @!attribute [rw] credit_to_new_allocation
    #   @return [Boolean] Creates a new allocation anytime {StoreCredit#credit} is called
    preference :credit_to_new_allocation, :boolean, default: false

    # searcher_class allows spree extension writers to provide their own Search class
    def searcher_class
      @searcher_class ||= Spree::Core::Search::Base
    end

    def searcher_class=(sclass)
      @searcher_class = sclass
    end

    # all the following can be deprecated when store prefs are no longer supported
    # @private
    DEPRECATED_STORE_PREFERENCES = {
      site_name: :name,
      site_url: :url,
      default_meta_description: :meta_description,
      default_meta_keywords: :meta_keywords,
      default_seo_title: :seo_title,
    }

    DEPRECATED_STORE_PREFERENCES.each do |old_preference_name, store_method|
      # Avoid warning about implementation details
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_silencer { |line| line =~ %r{spree/preferences} }

      # support all the old preference methods with a warning
      define_method "preferred_#{old_preference_name}" do
        ActiveSupport::Deprecation.warn("#{old_preference_name} is no longer supported on Spree::Config, please access it through #{store_method} on Spree::Store", bc.clean(caller))
        Store.default.send(store_method)
      end
    end
  end
end
