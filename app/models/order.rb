#encoding: utf-8
class Order
    include DataMapper::Resource

    property :id           , Serial 
    #property :user_id      , Integer
    property :out_trade_no , String #, :required => true, :unique => true # uniq id relate to alipay
    property :pre_paid_code, String #, :required => true, :unique => true 
    property :exp_id    , Integer # who use it
    property :exp_status, Boolean, :default => false # whether used
    property :quantity, Integer#, :required => true # all product number
    property :amount  , Float  #, :required => true # all products price total
    property :detail  , String #, :required => true # shop cart list 
    property :status  , Boolean, :default => false # whether transaction over
    property :ip      , String  # remote ip
    property :browser , String 
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now

    belongs_to :user, :required => false
    has n, :order_items

    #def build_relation_with_items
    #  JSON.parse("[%s]" % self.detail).each do |item|
    #    quantity = item.delete("quantity").to_i
    #    1.upto(quantity) do |i|
    #      item.merge!({
    #        :order_id            => self.id, 
    #        :pre_paid_code => uuid("%s-%d-%s" % [@order.detail, i, item.to_s]) 
    #      })
    #      OrderItem.create(item)
    #    end
    #  end
    #end
end

