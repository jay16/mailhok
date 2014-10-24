#encoding: utf-8
class Package
    include DataMapper::Resource

    property :id    , Serial 
    property :name  , String
    property :price , Float  , :default => 10.0
    property :num   , Integer, :default => 1
    property :unit  , String , :default => "年"
    property :onsale, Boolean, :default => false
    property :desc  , Text   , :default => ""
    property :created_at, DateTime, :default => DateTime.now
    property :updated_at, DateTime, :default => DateTime.now

end
