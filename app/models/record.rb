#encoding: utf-8
class Record # 开信记录
    include DataMapper::Resource
    include Utils::DataMapper

    property :id         ,Serial 
    property :track_id   ,String , :required => true, :unique => true
    property :ip         ,String
    property :browser    ,String  
    property :created_at ,DateTime, :default => DateTime.now
    property :updated_at ,DateTime, :default => DateTime.now

    belongs_to :track
end
