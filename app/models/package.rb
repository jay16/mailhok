#encoding: utf-8
class Package
    include DataMapper::Resource

    # 坑:
    # 1. creator_id/editor_id不可以设置为必填项,因为它们不是同一阶段设置
    # 2. created_at/updated_at/created_on/updated_on系统自动设置[dm-timestamps](!http://datamapper.org/docs/dm_more/timestamps.html)
    property :id    , Serial 
    property :name  , String
    property :price , Float  , :default => 10.0
    property :num   , Integer, :default => 1
    property :unit  , String , :default => "年"
    property :onsale, Boolean, :default => false
    property :desc  , Text   , :default => ""
    property :creator_id, Integer, :default => -1
    property :editor_id , Integer, :default => -1
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date
end
