#encoding: utf-8 
class Cpanel::OrdersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/orders"
  #set :haml, layout: :"../layouts/layout"


  # list
  # GET /cpanel/orders
  get "/" do
    @orders = Order.all

    haml :index, layout: :"../layouts/layout"
  end

  # new
  # GET /cpanel/new
  get "/new" do
    @order = Order.new

    haml :new, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/orders
  post "/" do
    params[:order].merge!({
      out_trade_no: uuid(params.to_s),
      pre_paid_code: uuid(params.to_s)
    })
    puts params[:order].inspect
    order = current_user.orders.create(params[:order])
    puts order.inspect

    redirect "/cpanel/orders"
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
    order.update(params[:order])

    redirect "/cpanel/orders/%d" % order.id
  end

  # delete
  # DELETE /cpanel/orders/:id
  delete "/:id" do
    order = Order.first(id: params[:id])
    order.destroy
  end
end
