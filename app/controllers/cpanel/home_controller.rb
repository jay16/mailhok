#encoding: utf-8 
class Cpanel::HomeController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/home"

  #无权限则登陆
  #当前controller中默认url path前缀为/cpanel
  #[local]  get "/hello"        => [global] get "/cpanel/hello"
  #[global] get "/cpanel/hello" => [local] request.path_info == "/hello"
  before do 
    authenticate!
  end

  # GET /cpanel
  get "/" do
    @users    = User.all
    @tracks   = Track.all
    @records  = Record.all
    @packages = Package.all
    @orders   = Track.all

    haml :index, layout: :"../layouts/layout"
  end

  # store
  # get /cpanel/store
  get "/store" do
    @packages = Package.onsale

    haml :store, layout: :"../layouts/layout"
  end

  # checkout
  # post /cpanel/checkout
  post "/checkout" do
    params[:order].merge!({
      out_trade_no: uuid(params.to_s),
      pre_paid_code: uuid(params.to_s)
    })
    order = current_user.orders.create(params[:order])
    JSON.parse("[%s]" % order.detail).each do |item|
      quantity = item.delete("quantity").to_i
      1.upto(quantity) do |i|
        item.merge!({
          pre_paid_code: uuid("%s-%d-%s" % [order.detail, i, item.to_s])
        })
        order_item = order.order_items.create(item)

        puts order_item.inspect
        puts "*"*10
      end
    end

    redirect "/cpanel/orders"
  end

  # get /cpanel/routes
  get "/routes" do
    rb_path = "%s/app/controllers/*.rb" % ENV["APP_ROOT_PATH"] 
    Dir.glob(rb_path).join("</br>")
  end

end
