#encoding: utf-8 
class Account::UserController< Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/user"
  before do
    authenticate!
  end

  # account
  # page index
  # GET /account
  get "/" do
    @campaigns = current_user.campaigns.normals
    @tracks    = current_user.tracks.normals
    @orders    = current_user.orders.normals

    haml :index, layout: :"../layouts/layout"
  end

  # get /account/edit
  get "/edit" do
    @user = User.first(id: current_user.id)

    haml :edit, layout: :"../layouts/layout"
  end

  # post /account/update
  post "/update" do
  end

  get "/store" do
    @packages = Package.all(:onsale => true)

    haml :"../../home/store", layout: :"../layouts/layout"
  end

  get "/action_logs" do
    @action_logs = current_user.action_logs(:order => [:created_at.desc])

    haml :action_log, layout: :"../layouts/layout"
  end
end
