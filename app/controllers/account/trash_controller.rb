#encoding: utf-8 
class Account::TrashController< Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/trash"
  before do
    authenticate!
  end

  # account
  # page index
  # GET /account
  get "/" do
    @tracks  = current_user.tracks.softs
    @records = current_user.records.softs
    @orders  = current_user.orders.softs

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

  get "/dash" do
    @tracks  = current_user.tracks.softs
    @records = current_user.records.softs
    @orders  = current_user.orders.softs
  end
end
