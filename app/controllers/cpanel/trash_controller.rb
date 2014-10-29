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

  # undo
  # POST /cpanel/trash/order/1/normal
  post "/:model/:id/:status" do
    _model = %w[tracks records orders packages].include?(params[:model]) 
    _statu = %w[normal].include?(params[:status])
    if _model and _statu
        obj = Object.const_get(params[:model].chop.capitalize)
          .first(id: params[:id])
        obj.update(delete_status: params[:status])
        cpanel_log(obj, "trash#%s" % obj.delete_status)
    else
      puts "Dirty Params: %s" % params.inspect
    end
  end
end
