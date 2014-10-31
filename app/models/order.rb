#encoding: utf-8
require "model-base"
class Order
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id,            Serial 
    property :out_trade_no , String , :unique => true # uniq id relate to alipay
    property :pre_paid_code, String , :unique => true 
    property :exp_id,        Integer # who use it
    property :exp_status,    Boolean, :default => false # whether used
    property :quantity,      Integer, :required => true # all product number
    property :amount,        Float  , :required => true # all products price total
    property :detail,        Text   , :required => true # shop cart list 
    property :status,        Boolean, :default => false # whether transaction over

    belongs_to :user, :required => false
    has n, :order_items

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end

    # instance methods
    def human_name
      "订单"
    end
    # class methods
    class << self
      # delete status
      def normals
        all(delete_status: "normal")
      end
      def not_normals
        all(:delete_status.not => "normal")
      end
      def softs
        all(delete_status: "soft")
      end
      def hards
        all(delete_status: "hard")
      end
    end
end

