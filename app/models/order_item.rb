#encoding: utf-8
require "dm-validations"
class OrderItem
    include DataMapper::Resource
    include Utils::DataMapper

    property :id           , Serial 
    #property :order_id     , Integer
    property :pre_paid_code, String , :unique => true 
    property :exp_id       , Integer # who use it
    property :package_id   , Integer
    property :package_name , Integer
    property :package_num  , Integer 
    property :package_unit , String
    property :package_price, Float  
    property :status , Boolean, :default => false # whether transaction over
    property :ip     , String  # remote ip
    property :browser, String 
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now

    belongs_to :order, :required => false
end
