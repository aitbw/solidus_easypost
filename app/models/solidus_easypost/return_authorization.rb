# frozen_string_literal: true

require 'forwardable'

module SolidusEasypost
  class ReturnAuthorization
    extend Forwardable

    attr_reader :return_authorization

    def_delegators :@return_authorization, :stock_location, :order, :inventory_units

    def initialize(return_authorization)
      @return_authorization = return_authorization
    end

    def easypost_shipment
      @easypost_shipment ||= ShipmentBuilder.from_return_authorization(self)
    end

    def return_label(rate)
      easypost_shipment.buy(rate) unless easypost_shipment.postage_label

      easypost_shipment.postage_label
    end
  end
end
