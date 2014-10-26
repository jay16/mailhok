#encoding: utf-8
require "dm-validations"
class Order
    include DataMapper::Resource

    property :id,            Serial 
    property :out_trade_no , String #, :required => true, :unique => true # uniq id relate to alipay
    property :pre_paid_code, String #, :required => true, :unique => true 
    property :exp_id,        Integer # who use it
    property :exp_status, Boolean, :default => false # whether used
    property :quantity, Integer#, :required => true # all product number
    property :amount,   Float  #, :required => true # all products price total
    property :detail,   Text#, :required => true # shop cart list 
    property :status,   Boolean, :default => false # whether transaction over
    property :ip,       String  # remote ip
    property :browser,  String 
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :user, :required => false
    has n, :order_items

    after :create do |order|
      puts "After :create doing..."
    end
    after :save do |order|
      puts "After :save doing..."
    end
end

