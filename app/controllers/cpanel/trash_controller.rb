#encoding: utf-8 
class Cpanel::TrashController< Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/trash"
  before do
    authenticate!
  end

  # account
  # page index
  # GET /account
  get "/" do
    @tracks  = Track.softs
    @records = Record.softs
    @orders  = Order.softs

    haml :index, layout: :"../layouts/layout"
  end
end
