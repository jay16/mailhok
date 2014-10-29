#encoding: utf-8
require "dm-validations"
class ActionLog
    include DataMapper::Resource

    property :id        , Serial 
    property :panel     , String   , :required => true
    property :user_id   , Integer  , :required => true
    property :model_name, String 
    property :model_id  , Integer
    property :action    , String
    property :detail    , Text
    property :created_at, DateTime
    property :created_on, Date
    property :updated_at, DateTime
    property :updated_on, Date

    belongs_to :user, :required => false

    after :create do |order|
      puts "After :create doing..."
    end
    after :save do |order|
      puts "After :save doing..."
    end

    # instance methods
    def account?
      panel == "account"
    end
    def cpanel?
      panel == "cpanel"
    end
end

