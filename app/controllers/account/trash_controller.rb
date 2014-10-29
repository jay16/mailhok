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

  # undo/hard destroy
  # POST /account/trash/order/1/normal
  post "/:model/:id/:status" do
    _model = %w[tracks records orders].include?(params[:model]) 
    _statu = %w[hard normal].include?(params[:status])
    if _model and _statu
      obj = current_user.send(params[:model])
        .first(id: params[:id])
      obj.update(delete_status: params[:status])
      account_log(obj, "trash#%s" % obj.delete_status)
    else
      puts "Dirty Params: %s" % params.inspect
    end
  end

  # soft => hard
  # DELETE /account/trash/clear"
  delete "/clear" do
    Order.softs.each(&:hard_destroy)
    Track.softs.each(&:hard_destroy)
    Record.softs.each(&:hard_destroy)
    account_log(obj, "trash#clear")
  end
end
