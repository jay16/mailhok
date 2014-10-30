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
    klass, ppc = params[:klass], params[:ppc]
    _before = current_user.expired_at.strftime("%Y-%m-%d %H:%M")
    obj = nil
    case klass 
    when "order"
      order = Order.first(pre_paid_code: ppc)
      order.order_items.each do |order_item|
        next if order_item.status
        current_user.update(expired_at: current_user.expired_at + order_item.package_num * 30)
        order_item.update(status: true)
      end
      order.update(status: true)
      obj = order
    when "order_item"
      order_item = OrderItem.first(pre_paid_code: ppc)
      if not order_item.status
        current_user.update(expired_at: current_user.expired_at + order_item.package_num * 30)
        order_item.update(status: true)
        # 修改所属order状态
        order = order_item.order
        if not order.status
          if order.order_items.map(&:status).uniq == [true]
            order.update(status: true)
          end
        end
      end
      obj = order_item
    end
    if obj and obj.valid?
      flash[:success] = (info = "成功续期: %s => %s" % [_before, current_user.expired_at.strftime("%Y-%m-%d %H:%M")])
      account_logger(order_item, "renewal#success", info)
      redirect "/account"
    else
      flash[:warning] = (info = "续期失败，请联系管理员!")
      account_logger(order_item, "renewal#failure", info)
      redirect "/account/renewal/%s/%s" % [ppc, klass]
    end
  end
end
