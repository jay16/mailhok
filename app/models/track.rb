#encoding: utf-8
require "model-base"
class Track # 用户创建追踪记录
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id       , Serial 
    property :user_id  , Integer
    property :record_id, Integer
    property :subject  , String #, :required => true, :unique => true
    property :email    , String
    property :desc     , Text
    property :uid      , String
    property :type     , String

    belongs_to :user
    has n, :records

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end
    # instance methods
    def human_name
      "追踪"
    end
end
