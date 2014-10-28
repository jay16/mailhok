#encoding: utf-8 
class Account::RenewalController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/renewal"

  # pre_paid_code usage
  # GET /account/renewal
  get "/" do
    haml :index, layout: :"../layouts/layout"
  end

  # POST /account/renewal/ppc
  post "/ppc" do
    ppc = params[:ppc]
    str = "/account/renewal/%s/%s?toke=%s"
    if ppc =~ regexp_ppc_order
      redirect str % [ppc, "order", uuid(ppc)]
    elsif ppc =~ regexp_ppc_order_item
      redirect str % [ppc, "order_item", uuid(ppc)]
    else
      redirect str % [ppc, "unvalid", uuid(ppc)]
    end
  end

  # get /account/renewal/:ppc/order
  get "/:ppc/order" do
    @order = Order.first(pre_paid_code: params[:ppc])
    haml :order, layout: :"../layouts/layout"
  end

  # get /account/renewal/:ppc/order_item
  get "/:ppc/order_item" do
    @order_item = OrderItem.first(pre_paid_code: params[:ppc])
    haml :order_item, layout: :"../layouts/layout"
  end

  # get /account/renewal/:ppcunvalid
  get "/:ppc/unvalid" do
  end

  # POST /account/renewal
  post "/" do
    info = current_user.expired_at.strftime("%Y-%m-%d %H:%M")
    if params[:klass] == "order"
      order = Order.first(pre_paid_code: params[:ppc])
      order.order_items.each do |order_item|
        next if order_item.status
        current_user.update(expired_at: current_user.expired_at + order_item.package_num * 30)
        order_item.update(status: true)
      end
      order.update(status: true)
      flash[:success] = "成功续期: %s => %s" % [info, current_user.expired_at.strftime("%Y-%m-%d %H:%M")]
      redirect "/account"
    end
  end
end
