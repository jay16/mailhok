#encoding: utf-8
module Utils
  module DataMapper
    module Model
      def self.included(base)
        base.send(:property, :delete_status, ::String, :default => "normal")
        base.send(:property, :ip,            ::String)
        base.send(:property, :browser,       ::DataMapper::Property::Text)
        base.send(:property, :created_at,    ::DateTime)
        base.send(:property, :created_on,    ::Date)
        base.send(:property, :updated_at,    ::DateTime)
        base.send(:property, :updated_on,    ::Date)
        base.send(:include, InstanceMethods)
      end

      def self.extended(base)
        base.extend ClassMethods
      end

      module InstanceMethods
        def _diff_(new, old)
          old.inject({}) do |diff, array|
            key, _old = array
            _new = new.fetch(key)
            next if ["updated_at"].include?(key) or _new == _old 

            puts "%s - %s: %s => %s" % [timestamp, key, _old, _new]
            diff.merge!({ key => { "new" => _new, "old" => _old } })
          end
        end
        def timestamp
          Time.now.strftime("%Y/%m/%d %H:%M:%S")
        end
        def _update_with_logger_(&block)
          old = to_params
          yield block
          new = to_params
          _diff = _diff_(new, old)
          if _diff.has_key?("delete_status")
            _action = "trash#%s" % delete_status
          end
          action_logger(self, _action || "update", _diff.to_s)
        end
        def soft_destroy
          update(delete_status: "soft")
        end
        def soft_destroy_with_logger
          _update_with_logger_ { soft_destroy }
        end
        def hard_destroy
          update(delete_status: "hard")
        end
        def hard_destroy_with_logger
          _update_with_logger_ { hard_destroy }
        end
        def update_with_logger(params)
          _update_with_loger_ { update(params) }
        end
        def delete?
          %w[soft hard].include?(delete_status)
        end
        def to_params
          self.class.properties.map(&:name)
            .reject(&:empty?)
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
