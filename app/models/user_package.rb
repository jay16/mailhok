#encoding: utf-8
#class UserPackage
#    include DataMapper::Resource
#
#    property :id            , Serial 
#    property :user_id       , Integer , :required => true # who buy it
#    property :package_id    , Integer , :required => true
#    property :trade_out_no  , String  , :required => true
#    property :pre_paid_code , String  , :required => true 
#    property :experiencer_id, Integer , :required => true # who use it
#    property :status        , Boolean , :default => false # whether used
#    property :created_at    , DateTime, :default => DateTime.now
#    property :updated_at    , DateTime, :default => DateTime.now
#end
