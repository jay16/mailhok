#encoding: utf-8 
class Cpanel::OrdersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/orders"
  #set :haml, layout: :"../layouts/layout"

  # list
  # GET /cpanel/orders
  get "/" do
    @orders = Order.normals

    haml :index, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/orders
  post "/" do
    Order.raise_on_save_failure = false
    order_params = params[:order].merge({
      out_trade_no:  uuid(params.to_s),
      pre_paid_code: Time.now.to_f.to_s
    })
    order = current_user.orders.new(order_params)
    if order.save
      status = "/%d" % order.id
      pre_paid_code = "%s%du%do%s" % ["ppc", order.user_id, order.id, sample_3_alpha]
      order.update(:pre_paid_code => pre_paid_code)
      build_relation_with_items(order)
    else
      puts "Failed to save order: %s" % order.errors.inspect
    end

      redirect "/cpanel/orders%s" % (status || "")
  end

  # show 
  # GET /cpanel/orders/:id
  get "/:id" do
    @order = Order.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  # edit
  # GET /cpanel/orders/:id/edit
  get "/:id/edit" do
    @order = Order.first(id: params[:id])

    haml :edit, layout: :"../layouts/layout"
  end

  # update
  # POST /cpanel/orders/:id
  post "/:id" do
    order = Order.first(id: params[:id])
    order.update_with_logger(params[:order])

    redirect "/cpanel/orders/%d" % order.id
  end

  # delete
  # DELETE /cpanel/orders/:id
  delete "/:id" do
    order = Order.first(id: params[:id])
    order.soft_destroy_with_logger
  end

end
