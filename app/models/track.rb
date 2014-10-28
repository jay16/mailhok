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
    property :delete_status, String, :default => "normal"
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :user
    has n, :records

    # class methods
    class << self
      # delete status
      def normals
        all(delete_status: "normal")
      end
      def not_normals
        all(:delete_status.not => "normal")
      end
      def softs
        all(delete_status: "soft")
      end
      def hards
        all(delete_status: "hard")
      end
    end
end
