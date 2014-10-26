#encoding: utf-8
class Record # 开信记录
    include DataMapper::Resource
    include Utils::DataMapper

    property :id         ,Serial 
    property :track_id   ,String , :required => true, :unique => true
    property :ip         ,String
    property :browser    ,String  
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :track
end
