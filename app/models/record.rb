#encoding: utf-8
class Record # 开信记录
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id         ,Serial 
    property :track_id   ,String , :required => true, :unique => true
    property :ip         ,String
    property :browser    ,String  

    belongs_to :track

    after :create do |obj|
      action_logger(obj, "create", obj.to_params)
    end
    # instance methods
    def human_name
      "开信记录"
    end
end
