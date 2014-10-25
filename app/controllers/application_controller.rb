#encoding: utf-8
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

  def uuid(str)
    str += Time.to_s + rand(10000).to_s
    Digest::MD5.hexdigest(str)
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
