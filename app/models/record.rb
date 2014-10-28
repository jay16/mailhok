#encoding: utf-8
class Record # 开信记录
    include DataMapper::Resource
    include Utils::DataMapper

    property :id         ,Serial 
    property :track_id   ,String , :required => true, :unique => true
    property :ip         ,String
    property :browser    ,String  
    property :delete_status, String, :default => "normal"
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :track

    # delete status
    class << self
      def normals
        all(delete_status: "normal")
      end
      def softs
        all(delete_status: "soft")
      end
      def hards
        all(delete_status: "hard")
      end
    end
end
