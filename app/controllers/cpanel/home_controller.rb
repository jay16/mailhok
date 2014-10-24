#encoding: utf-8 
class Cpanel::HomeController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/home"

  #无权限则登陆
  #当前controller中默认url path前缀为/cpanel
  #[local]  get "/hello"        => [global] get "/cpanel/hello"
  #[global] get "/cpanel/hello" => [local] request.path_info == "/hello"
  before do 
    authenticate!
  end

  # GET /cpanel
  get "/" do
    @users    = User.all
    @tracks   = Track.all
    @records  = Record.all
    @packages = Package.all

    haml :index, layout: :"../layouts/layout"
  end

  # get /cpanel/routes
  get "/routes" do
    rb_path = "%s/app/controllers/*.rb" % ENV["APP_ROOT_PATH"] 
    Dir.glob(rb_path).join("</br>")
  end

end
