module PiggybakPaypal
  module PaymentDecorator
    extend ActiveSupport::Concern

    included do
      attr_accessor :token
      attr_accessor :payer_id

      include ActiveModel::ForbiddenAttributesProtection

      before_validation :set_defaults, :on => :create

      def set_defaults
        if self.token && self.payer_id
          Rails.logger.warn("****** Using bogus cc info *****")
          self.number = '4111111111111111'
          self.month = Time.now.month
          self.year = Time.now.year
          self.verification_value = '111'
        end
      end

      def process(order)
        return true if !self.new_record?

        # if transaction_id is present this is paypal_express

          ActiveMerchant::Billing::Base.mode = Piggybak.config.activemerchant_mode

          calculator = ::PiggybakPaypal::PaymentCalculator::Paypal.new(self.payment_method)
          self.month = Time.now.month
          self.year = Time.now.year
          Rails.logger.debug("PayerID = #{order.payer_id}, Token = #{order.token}")
          order_total = (order.total_due * 100).to_i
          res = calculator.gateway.purchase(order_total,{
            :ip => order.ip_address, 
            :token => order.token,
            :payer_id => order.payer_id}
          )

        if res.success?
          return true
        else
          order.errors.add :payment_method_id, res.message.to_s
          return false
        end
      end

    end
  end
end
