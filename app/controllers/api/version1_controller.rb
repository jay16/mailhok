#encoding: utf-8
require 'digest/md5'
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
      :now  => DateTime.now.strftime("%Y/%m/%d %H:%M:%S"),
      :expired_at => expired_at
    }

    respond json, 200
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

    respond json, 200
  end

  # post /api/v1/track/url
  post "/track/url.json" do
    subject = params[:subject]
    uid     = params[:uid]
    email   = params[:mid]
    desc    = params[:to]
    _uid = "%s%s%s%s%d%d" % [subject, uid, email, desc, Time.now.to_i, rand()]
    uid = Digest::MD5.hexdigest(_uid)
    track = Track.create({
      :subject => subject,
      :user_id => uid,
      :email   => email,
      :desc    => desc,
      :uid     => uid,
      :type    => "api1"
    })
    
    json = {
      :code => 200,
      :url  => "%s/%s" % [Settings.api.base_url, track.uid]
    }
    respond json, 200
  end

  # pre-paid-code
  # get /api/v1/:pre_paid_type/generate
  get "/:pre_paid_type/pre_paid_code.json" do
    if @current_user 
      pre_paid_type = "%s%d%s%d%d" % [@current_user.email, @current_user.id, params[:pre_paid_type], Time.now.to_i, rand()]
      pre_paid_code = Digest::MD5.hexdigest(pre_paid_type.to_s)
      json = { 
        :pre_paid_type => params[:pre_paid_type],
        :pre_paid_code => pre_paid_code
      }
    else
      json = {}
    end
    respond json, (json.empty? ? 401 : 200)
  end
end
