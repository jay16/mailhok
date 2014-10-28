#encoding: utf-8 
class Account::OrdersController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/orders"

  # list
  # GET /cpanel/orders
  get "/" do
    @orders = current_user.orders.normals

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
  # GET /orders/:id
  get "/:id" do
    @order = current_user.orders.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  ## edit
  ## GET /orders/:id/edit
  #get "/:id/edit" do
  #  @order = current_user.orders.first(id: params[:id])

  #  haml :edit, layout: :"../layouts/layout"
  #end

  ## update
  ## POST /orders/:id
  #post "/:id" do
  #  order = current_user.orders.first(id: params[:id])
  #  order.update(params[:order])

  #  redirect "/cpanel/orders/%d" % order.id
  #end

  # delete
  # DELETE /cpanel/orders/:id
  delete "/:id" do
    order = current_user.orders.first(id: params[:id])
    order.order_items.destroy
    order.destroy
  end

  private
    def build_relation_with_items(order)
      JSON.parse("[%s]" % order.detail).each_with_index do |item, index|
        quantity = item.delete("quantity").to_i
        1.upto(quantity) do |i|
          item.merge!({ pre_paid_code: Time.now.to_f.to_s })
          order_item = order.order_items.new(item)
          if order_item.save
            pre_paid_code = "%s%du%do%di%s" % ["ppc", order.user_id, order.id, order_item.id, sample_3_alpha]
            order_item.update(:pre_paid_code => pre_paid_code)
          else
            puts "Failed to save order_item: %s" % order_item.errors.inspect
          end
        end
      end
    end
end
