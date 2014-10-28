#encoding: utf-8 
class Cpanel::TrashController< Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/trash"
  before do
    authenticate!
  end

  # GET /account
  get "/" do
    @tracks  = Track.not_normals
    @records = Record.not_normals
    @orders  = Order.not_normals
    @packages = Package.not_normals

    haml :index, layout: :"../layouts/layout"
  end
end
