#encoding: utf-8
require "model-base"
class Track # 开信记录
    include DataMapper::Resource
    include Utils::DataMapper::Model
    extend  Utils::DataMapper::Model
    #include Utils::ActionLogger

    property :id, Serial

    belongs_to :campaign, :required => false

    # instance methods
    def human_name
      "开信记录"
    end
end
