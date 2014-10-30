#encoding: utf-8
require "model-base"
class ApiLog
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model

    property :id, Serial 
    property :image, String # image
    property :name, String, :required => true # name
    property :market, String # market desc, eg, 2014 spring recommand 
    property :blog, String # tea describtion blog link 
    property :from, String # produce source 
    property :price, Float, :required => true # price 
    property :unit1, String # price unit 
    property :unit2, String # product unit 
    property :weight, Float # weight 
    property :unit3, String # weight unit
    property :desc, String  # describtion
    property :onsale, Boolean,  :default => false # whether onsale
end
