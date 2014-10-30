#encoding: utf-8
module Utils
  module DataMapper
    module Model
      def self.included(base)
        base.send(:property, :delete_status, String, :default => "normal")
        base.send(:property, :ip,       String)
        base.send(:property, :browser,  String)
        base.send(:property, :created_at, DateTime)
        base.send(:property, :created_on, Date)
        base.send(:property, :updated_at, DateTime)
        base.send(:property, :updated_on, Date)
        base.send(:include, InstanceMethods)
      end

      def self.extended(base)
        base.extend ClassMethods
      end

      module InstanceMethods
        def soft_destroy
          update(delete_status: "soft")
        end
        def hard_destroy
          update(delete_status: "hard")
        end
        def delete?
          %w[soft hard].include?(delete_status)
        end
        def to_params
          self.class.properties.map(&:name).reject(&:empty?)
          .inject({}) do |hash, property| 
            hash.merge!({ "%s" % property => self.send(property) })
          end
        end
      end

      module ClassMethods
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
  end
end
