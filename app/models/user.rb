﻿#encoding: utf-8
require "model-base"
class User
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

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

    has n, :orders
    has n, :action_logs
    has n, :tracks
    has n, :records, :through => :tracks

    def admin?
      @is_admin ||= Settings.admins.split(/;/).include?(self.email)
    end

    # instance methods
    def human_name
      "用户"
    end
end
