#encoding: utf-8
class Track # 用户创建追踪记录
    include DataMapper::Resource
    include Utils::DataMapper

    property :id       , Serial 
    property :user_id  , Integer
    property :record_id, Integer
    property :subject  , String #, :required => true, :unique => true
    property :email    , String
    property :desc     , Text
    property :uid      , String
    property :type     , String
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :user
    has n, :records
end
