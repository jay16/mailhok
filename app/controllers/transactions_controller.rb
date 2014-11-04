﻿#encoding: utf-8 
require "json"
class TransactionsController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/transactions"

  #post /transactions/checkout
  post "/checkout" do
    #生成唯一out_trade_no
    out_trade_no = generate_out_trade_no

    options = {
      :partner       => Settings.alipay.pid,
      :key           => Settings.alipay.secret,
      :seller_email  => Settings.alipay.seller_email,
      :description   => params[:order][:detail],
      :out_trade_no  => out_trade_no,
      :subject       => "MailHok订单 - ￥" + params[:order][:amount].to_s,
      :price         => params[:order][:amount],
      :quantity      => 1,
      :discount      => '0.00',
      :return_url    => Settings.alipay.return_url,
      :notify_url    => Settings.alipay.notify_url
    }

    order_params = params[:order].merge({
      out_trade_no:  uuid(params.to_s),
      pre_paid_code: Time.now.to_f.to_s
    })
    order = current_user.orders.new(order_params)
    if order.save
      pre_paid_code = "%s%du%do%s" % ["ppc", order.user_id, order.id, sample_3_alpha]
      order.update(:pre_paid_code => pre_paid_code)
      build_relation_with_items(order)
    else
      puts "Failed to save order: %s" % order.errors.inspect
    end
    Order.create({ 
      :out_trade_no => out_trade_no,
      :quantity => params[:quantity],
      :amount   => params[:amount],
      :detail   => params[:details],
      :ip       => remote_ip,
      :browser  => remote_browser
    })

    redirect AlipayDualfun.trade_create_by_buyer_url(options)
  end

  # post /transactions/notify
  post "/notify" do
    find_or_create_transaction!

    haml :notify
  end

  # get /transactions/done
  get "/done" do
    @status, @transaction = find_or_create_transaction!
    @order = Order.all(:out_trade_no => @transaction.out_trade_no).first

    flash[:success] = "付款成功啦!"
    haml :done, layout: :"../layouts/layout"
  end

  # show
  # get /transactions/:out_trade_no
  get "/:out_trade_no" do
    @transaction = Transaction.first(:out_trade_no => params[:out_trade_no])
    @order = Order.first(:out_trade_no => params[:out_trade_no])

    @columns = { 
      :out_trade_no    => "订单号",
      :subject         => "订单标题",
      :total_fee       => "订单金额",
      :seller_actions  => "卖家待做",
      :receive_name    => "买家名称",
      :buyer_email     => "买家邮箱",
      :receive_mobile  => "买家手机号",
      :receive_address => "买家地址",
      :gmt_payment     => "付款时间",
      :receive_zip     => "买家邮编"
    }

    haml :show, layout: :"../layouts/layout"
  end
 
  def find_or_create_transaction!
    # %(WAIT_SELLER_SEND_GOODS WAIT_SELLER_SEND_GOODS).include?(params[:trade_status])
    transaction = Transaction.all(:out_trade_no => params[:out_trade_no]).first
    status = "action: "
    params.merge!({ ip: remote_ip, browser: remote_browser })

    #存在则更新，不存在则创建
    if transaction.nil?
      params.merge!({ created_at: DateTime.now, updated_at: DateTime.now })
      transaction = Transaction.create(params)
      status += "create; status: "
      status += (transaction.saved? ? "true" : "false")
    else
      params.merge!({ updated_at: DateTime.now })
      transaction.update(params)
      status += "update; status: " + (transaction.saved? ? "true" : "false")
    end

    [status, transaction]
  end

  def generate_out_trade_no
    ip_hex = remote_ip.split(".").map{ |is| ("%02X" % is.to_i).to_s }.join.hex
    Time.now.to_i.to_s + ip_hex.to_s + Order.count.to_s
  end

end
