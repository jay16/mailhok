#encoding: utf-8 
class Account::RenewalController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/renewal"

  # pre_paid_code usage
  # GET /renewal
  get "/" do
    haml :index, layout: :"../layouts/layout"
  end

  # POST /renewal/ppc
  post "/ppc" do
    ppc = params[:ppc]
    if ppc =~ regexp_ppc_order
      redirect "/renewal/%s/order?toke=%s" % [ppc, uuid(ppc)]
    elsif ppc =~ regexp_ppc_order_item
      redirect "/renewal/%s/order_item?toke=%s" % [ppc, uuid(ppc)]
    else
      redirect "/renewal/%s/unvalid?toke=%s" % [ppc, uuid(ppc)]
    end
  end

  # get /renewal/:ppc/order
  get "/:ppc/order" do
    @order = Order.first(pre_paid_code: params[:ppc])
    haml :order, layout: :"../layouts/layout"
  end

  # get /renewal/:ppc/order_item
  get "/:ppc/order_item" do
    @order_item = OrderItem.first(pre_paid_code: params[:ppc])
    haml :order_item, layout: :"../layouts/layout"
  end

  # get /ppc/unvalid
  get "/unvalid" do
  end

  # POST /ppc/renewal
  post "/" do
    info = current_user.expired_at.strftime("%Y-%m-%d %H:%M")
    if params[:klass] == "order"
      order = Order.first(pre_paid_code: params[:ppc])
      order.order_items.each do |order_item|
        next if order_item.status
        current_user.update(expired_at: current_user.expired_at + order_item.package_num * 30)
      end
      flash[:success] = "成功续期: %s => %s" % [info, current_user.expired_at.strftime("%Y-%m-%d %H:%M")]
      redirect "/account"
    end
  end
end
