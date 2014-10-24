#encoding: utf-8
class Order
    include DataMapper::Resource

    property :id           , Serial 
    property :user_id      , Integer, :required => true
    property :package_id   , Integer, :required => true
    property :out_trade_no , String , :unique => true # uniq id relate to alipay
    property :pre_paid_code, String , :unique => true 
    property :exp_id    , Integer, :required => true # who use it
    property :exp_status, Boolean, :default => false # whether used
    property :detail , String  # shop cart list 
    property :status , Boolean # whether transaction over
    property :ip     , String  # remote ip
    property :browser, String 
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now

    belongs_to :user
end
