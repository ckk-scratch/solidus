module Spree
  module Api
    class CheckoutsController < Spree::Api::BaseController
      before_filter :load_order, only: [:next, :advance, :update, :complete]
      around_filter :lock_order, only: [:next, :advance, :update, :complete]
      before_filter :update_order_state, only: [:next, :advance, :update, :complete]

      rescue_from Spree::Order::InsufficientStock, with: :insufficient_stock_error

      include Spree::Core::ControllerHelpers::Order
      # This before_filter comes from Spree::Core::ControllerHelpers::Order
      skip_before_action :set_current_order

      def next
        if @order.confirm?
          ActiveSupport::Deprecation.warn "Using Spree::Api::CheckoutsController#next to transition to complete is deprecated. Please use #complete instead of #next.", caller
          complete
          return
        end

        authorize! :update, @order, order_token
        if !expected_total_ok?(params[:expected_total])
          respond_with(@order, default_template: 'spree/api/orders/expected_total_mismatch', status: 400)
          return
        end
        authorize! :update, @order, order_token
        @order.next!
        respond_with(@order, default_template: 'spree/api/orders/show', status: 200)
      rescue StateMachines::InvalidTransition
        respond_with(@order, default_template: 'spree/api/orders/could_not_transition', status: 422)
      end

      def advance
        authorize! :update, @order, order_token
        @order.contents.advance
        respond_with(@order, default_template: 'spree/api/orders/show', status: 200)
      end

      def complete
        authorize! :update, @order, order_token
        if !expected_total_ok?(params[:expected_total])
          respond_with(@order, default_template: 'spree/api/orders/expected_total_mismatch', status: 400)
        else
          @order.complete!
          respond_with(@order, default_template: 'spree/api/orders/show', status: 200)
        end
      rescue StateMachines::InvalidTransition
        respond_with(@order, default_template: 'spree/api/orders/could_not_transition', status: 422)
      end

      def update
        authorize! :update, @order, order_token

        if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
          if current_api_user.has_spree_role?('admin') && user_id.present?
            @order.associate_user!(Spree.user_class.find(user_id))
          end

          return if after_update_attributes

          if @order.completed? || @order.next
            state_callback(:after)
            respond_with(@order, default_template: 'spree/api/orders/show')
          else
            respond_with(@order, default_template: 'spree/api/orders/could_not_transition', status: 422)
          end
        else
          invalid_resource!(@order)
        end
      end

      private
        def user_id
          params[:order][:user_id] if params[:order]
        end

        def nested_params
          map_nested_attributes_keys Order, params[:order] || {}
        end

        # Should be overriden if you have areas of your checkout that don't match
        # up to a step within checkout_steps, such as a registration step
        def skip_state_validation?
          false
        end

        def load_order
          @order = Spree::Order.find_by!(number: params[:id])
          raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
        end

        def update_order_state
          @order.state = params[:state] if params[:state]
          state_callback(:before)
        end

        def raise_insufficient_quantity
          respond_with(@order, default_template: 'spree/api/orders/insufficient_quantity')
        end

        def state_callback(before_or_after = :before)
          method_name = :"#{before_or_after}_#{@order.state}"
          send(method_name) if respond_to?(method_name, true)
        end

        def after_update_attributes
          if nested_params && nested_params[:coupon_code].present?
            handler = PromotionHandler::Coupon.new(@order).apply

            if handler.error.present?
              @coupon_message = handler.error
              respond_with(@order, default_template: 'spree/api/orders/could_not_apply_coupon')
              return true
            end
          end
          false
        end

        def order_id
          super || params[:id]
        end

        def expected_total_ok?(expected_total)
          return true if expected_total.blank?
          @order.total == BigDecimal(expected_total)
        end
    end
  end
end
