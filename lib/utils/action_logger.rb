#encoding: utf-8
module Utils
  module ActionLogger
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def base_log(panel, model, action, detail)
        _action = {
          "create" => "创建",
          "update" => "更新",
          "destroy" => "删除",
          "trash#soft"   => "删除",
          "trash#hard"   => "从回收站删除",
          "trash#normal" => "从回收站还原",
          "trash#clear"  => "清空回收站"
        }.fetch(action, action)
        ActionLog.create({
          :panel      => panel,
          :user_id    => (model.human_name == "用户" ? model : model.user).id,
          :model_name => model.class.name,
          :model_id   => model.id,
          :action     => "%s %s" % [_action, model.human_name],
          :detail     => detail
        })
      end
      def action_logger(model, action, detail)
        base_log("model", model, action, detail)
      end
      def account_log(model, action, detail="")
        base_log("account", model, action, detail)
      end
      def cpanel_log(model, action, detail="")
        base_log("cpanel", model, action, detail)
      end
    end
  end
end
