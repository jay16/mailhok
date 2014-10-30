#encoding: utf-8
require "model-base"
class Track # 用户创建追踪记录
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id       , Serial 
    property :subject  , String #, :required => true, :unique => true
    property :to       , String # to
    property :tos      , Text   # when to out limit
    property :desc     , Text
    property :mid      , String# , :unique => true# for api query, 
    property :type     , String , :default => "web"

    belongs_to :user, :required => false
    has n, :records

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end
    # instance methods
    def human_name
      "追踪"
    end
end
