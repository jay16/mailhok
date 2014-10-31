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
    @users     = User.normals
    @campaigns = Campaign.normals
    @tracks    = Track.normals
    @packages  = Package.normals
    @orders    = Order.normals

    haml :index, layout: :"../layouts/layout"
  end

  # store
  # get /cpanel/store
  get "/store" do
    @packages = Package.onsale

    haml :store, layout: :"../layouts/layout"
  end

  # get /cpanel/routes
  get "/routes" do
    rb_path = "%s/app/controllers/*.rb" % ENV["APP_ROOT_PATH"] 
    Dir.glob(rb_path).join("</br>")
  end

  # get /cpanel/action_logs
  get "/action_logs" do
    @action_logs = ActionLog.all(:order => [:created_at.desc])

    haml :action_log, layout: :"../layouts/layout"
  end

end
