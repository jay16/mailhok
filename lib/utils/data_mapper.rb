#encoding: utf-8
module Utils
  module DataMapper
    def to_params
      self.class.properties.map(&:name).reject(&:empty?)
      .inject({}) do |hash, property| 
        hash.merge!({ "%s" % property => self.send(property) })
      end
    end
  end
end
