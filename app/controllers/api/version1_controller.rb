#encoding: utf-8
class API::Version1 < API::ApplicationController
  before do; 
    authenticate! 
  end
  
  # user
  # get /api/v1/user/login
  get "/user/login.json" do 
    return unless @current_user

    expired_at = (@current_user.expired_at || DateTime.now).strftime("%Y/%m/%d %H:%M:%S")
    json = {
      :code => 200,
      :uid  => @current_user.id,
      :now  => DateTime.now.strftime("%Y/%m/%d %H:%M:%S"),
      :expired_at => expired_at,
      :notifications => ""
    }
    respond json
  end

  get "/user/validate.json" do
    return unless @current_user

    register_at = @current_user.created_at.strftime("%Y/%m/%d %H:%M:%S")
    expired_at = (@current_user.expired_at || DateTime.now).strftime("%Y/%m/%d %H:%M:%S")
    json = {
      :code => 200,
      :now  => DateTime.now.strftime("%Y/%m/%d %H:%M:%S"),
      :name        => @current_user.name,
      :register_at => register_at,
      :paid_at     => @current_user.paid_at,
      :expired_at  => expired_at
    }

    respond json
  end

  # post /api/v1/campaigns.json
  get "/campaigns.json" do
    return unless @current_user 
    json = {}
    if params[:mid].nil?
      json[:code] = 500
      json[:errors] = { "mid" => ["mid is necessary"] }
    else
      if campaign = @current_user.campaigns.first(mid: params[:mid])
        json[:code] = 200
        json[:url]  = %Q(<img src="%s/%s">) % [Settings.api.v1.url, campaign.mid]
      else
        campaign = @current_user.campaigns.new({
          :subject => params[:subject],
          :to      => params[:to],
          :tos     => params[:tos],
          :mid     => params[:mid],
          :type    => "api1"
        })
        if campaign.save
          json[:code] = 200
          json[:url]  = %Q(<img src="%s/%s">) % [Settings.api.v1.url, campaign.mid]
        else
          errors = []
          campaign.errors.each_pair do |key, value|
            errors.push({ key => value })
          end
          json[:code]   = 500
          json[:errors] = errors
        end
      end
    end
    respond json
  end

  # pre-paid-code
  # get /api/v1/:pre_paid_type/generate
  get "/:pre_paid_type/pre_paid_code.json" do
    return unless @current_user 
    pre_paid_type = "%s%d%s%d%d" % [@current_user.email, @current_user.id, params[:pre_paid_type], Time.now.to_i, rand()]
    pre_paid_code = uuid(pre_paid_type.to_s)
    json = { 
      :code => 200,
      :pre_paid_type => params[:pre_paid_type],
      :pre_paid_code => pre_paid_code
    }
    respond json
  end
end
