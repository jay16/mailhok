#encoding: utf-8
require "model-base"
class Package
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

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

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end
    # instance methods
    def human_name
      "套餐"
    end
    def user
      @current_user ||= User.first(id: creator_id)
    end
    def creator
      @current_user ||= User.first(id: creator_id)
    end
    # class methods
    class << self
      # sale status
      def onsale
        all(onsale: true)
      end
      def outsale
        all(onsale: false)
      end
    end
end
