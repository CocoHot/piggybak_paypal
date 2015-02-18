module PiggybakPaypal
  class PaypalController < ApplicationController
    layout 'application'
    before_filter :set_payment_method

    def express
      if @payment_method && @cart
        calculator = ::PiggybakPaypal::PaymentCalculator::Paypal.new(@payment_method)
        url = calculator.generate_express_url(
          cart: @cart,
          ip_address: request.remote_ip,
          return_url: paypal_process_url,
          cancel_url: "http://#{request.host}"
        )
        redirect_to url
      end
    end

    def process_express
      calculator = ::PiggybakPaypal::PaymentCalculator::Paypal.new(@payment_method)
      details = calculator.details_from_token(paypal_token_param)
      @order = Piggybak::Order.new(details)
      @order.create_payment_shipment
      @cart.set_extra_data(details[:shipping_address_attributes])
      @shipping_options = shipping_methods = Piggybak::ShippingMethod.lookup_methods(@cart)
      @token = paypal_token_param
      @payer_id = paypal_payer_param
    end

    def set_payment_method
      @cart = Piggybak::Cart.new(request.cookies["cart"])
      @payment_method = Piggybak::PaymentMethod.where(klass: "::PiggybakPaypal::PaymentCalculator::Paypal").first()
    end


  private
    def paypal_token_param
      params.require(:token)
    end

    def paypal_payer_param
      params.require(:PayerID)
    end


  end
end
