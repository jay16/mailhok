#encoding: utf-8
class User
    include DataMapper::Resource
    include Utils::DataMapper

    property :id        , Serial 
    property :email     , String  , :required => true, :unique => true
    property :name      , String
    property :password  , String
    property :gender    , Boolean 
    property :country   , String  
    property :province  , String  
    property :city      , String  
    property :expired_at, DateTime  , :default => DateTime.now
    property :paid_at   , String  
    property :package_id, String  
    property :delete_status, String, :default => "normal"
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    has n, :orders
    has n, :tracks
    has n, :records, :through => :tracks

    def admin?
      Settings.admins.split(/;/).include?(self.email)
    end

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
