#encoding: utf-8
require "model-base"
class OrderItem
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id           , Serial 
    property :pre_paid_code, String , :unique => true 
    property :exp_id       , Integer # who use it
    property :package_id   , Integer
    property :package_name , String
    property :package_num  , Integer 
    property :package_unit , String
    property :package_price, Float  
    property :status ,       Boolean, :default => false # whether transaction over

    belongs_to :order, :required => false
end
