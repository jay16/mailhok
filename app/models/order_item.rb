#encoding: utf-8
require "dm-validations"
class OrderItem
    include DataMapper::Resource
    #include Utils::DataMapper

    property :id           , Serial 
    property :pre_paid_code, String , :unique => true 
    property :exp_id       , Integer # who use it
    property :package_id   , Integer
    property :package_name , String
    property :package_num  , Integer 
    property :package_unit , String
    property :package_price, Float  
    property :status ,       Boolean, :default => false # whether transaction over
    property :created_at,    DateTime
    property :created_on,    Date
    property :updated_at,    DateTime
    property :updated_on,    Date

    belongs_to :order, :required => false
end
