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
    property :expired_at, String  , :default => DateTime.now
    property :paid_at   , String  
    property :package_id, String  
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
end
