﻿#encoding: utf-8
#require 'sinatra/advanced_routes'
require 'digest/md5'
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  # register Sinatra::AdvancedRoutes
  # register Sinatra::Auth

  helpers ApplicationHelper
  helpers TransactionsHelper
  helpers HomeHelper
  helpers Sinatra::FormHelpers
  
  enable :sessions, :logging, :dump_errors, :raise_errors, :static, :method_override

  # css/js/view配置文档
  use ImageHandler
  use SassHandler
  use CoffeeHandler
  use AssetHandler

  # global functions list
  def remote_ip
    request.env["REMOTE_ADDR"] || "n-i-l"
  end

  def remote_path
    request.env["REQUEST_PATH"] || "/"
  end

  def remote_browser
    request.env["HTTP_USER_AGENT"] || "n-i-l"
  end

  def run_shell(cmd)
    IO.popen(cmd) { |stdout| stdout.reject(&:empty?) }.unshift($?.exitstatus.zero?)
  end 

  ##### global function ####
  def uuid(str)
    str += Time.to_s + rand(10000).to_s
    Digest::MD5.hexdigest(str)
  end
  def sample_3_alpha
    (('a'..'z').to_a + ('A'..'Z').to_a).sample(3).join
  end
  def regexp_ppc_order
    @regexp_ppc_order ||= Regexp.new(Settings.regexp.order)
  end
  def regexp_ppc_order_item
    @regexp_ppc_order_item ||= Regexp.new(Settings.regexp.order_item)
  end
  ##### =============== #####
  # action log
  def base_log(panel, model, action, detail)
    _action = {
      "create" => "创建",
      "update" => "更新",
      "destroy" => "删除",
      "trash#hard"   => "从回收站删除",
      "trash#normal" => "从回收站还原",
      "trash#clear"  => "清空回收站"
    }.fetch(action, action)
    ActionLog.create({
      :panel      => panel,
      :user_id    => current_user.id,
      :model_name => model.class.name,
      :model_id   => model.id,
      :action     => "%s %s" % [_action, model.human_name],
      :detail     => detail
    })
  end
  def account_log(model, action, detail="")
    base_log("account", model, action, detail)
  end
  def cpanel_log(model, action, detail="")
    base_log("cpanel", model, action, detail)
  end

  def current_user
    @current_user ||= User.first(email: request.cookies["cookie_user_login_state"])
  end

  # filter
  def authenticate! 
    if request.cookies["_login_state"].to_s.strip.empty?
      # 记录登陆前的path，登陆成功后返回至此path
      response.set_cookie "cookie_before_login_path", {:value=> request.url, :path => "/", :max_age => "2592000"}

      flash[:notice] = "继续操作前请登录."
      redirect "/user/login", 302
    end
  end

  # 404 page
  not_found do
    haml :"shared/not_found", layout: :"layouts/layout", views: ENV["VIEW_PATH"]
  end
end
