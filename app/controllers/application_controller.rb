#encoding: utf-8
#require 'sinatra/advanced_routes'
require 'digest/md5'
class ApplicationController < Sinatra::Base
  before do
    params = (params || {}).merge({
      :ip      => remote_ip,
      :browser => remote_browser
    })
    puts "%s - Params: %s" % [Time.now.to_s, params.to_s]
  end

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
    request.ip 
  end
  def remote_path
    request.path 
  end
  def remote_browser
    request.user_agent
  end
  def run_shell(cmd)
    IO.popen(cmd) { |stdout| stdout.reject(&:empty?) }.unshift($?.exitstatus.zero?)
  end 
  # global function
  def uuid(str)
    str += Time.now.to_f.to_s
    md5_key(str)
  end
  def md5_key(str)
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

  def current_user
    @current_user ||= User.first(email: request.cookies["cookie_user_login_state"])
  end
  # action_logger
  # current_user
  include Utils::ActionLogger

  # filter
  def authenticate! 
    if request.cookies["cookie_user_login_state"].to_s.strip.empty?
      # 记录登陆前的path，登陆成功后返回至此path
      response.set_cookie "cookie_before_login_path", {:value=> request.url, :path => "/", :max_age => "2592000"}

      flash[:notice] = "继续操作前请登录."
      redirect "/user/login", 302
    end
  end

  # format gem#dm-validations errors info
  def format_dv_errors(model)
    errors = []
    model.errors.each_pair do |key, value|
      errors.push({ key => value })
    end
    return errors
  end

  # 404 page
  not_found do
    haml :"shared/not_found", layout: :"layouts/layout", views: ENV["VIEW_PATH"]
  end
end
