#encoding: utf-8
module API; end
class API::ApplicationController < ApplicationController
  def respond_with_json _body, _status = 200
    content_type "application/json"
    body   _body.to_json
    status _status 
  end

  alias_method :respond, :respond_with_json

  def authenticate! 
    condition = {
        :email    => params[:email] || "nil",
        :password => params[:password] || "nil"
    } 
    if user = User.first(condition)
        @current_user = user
    else
      json = { code: 401, now: DateTime.now.strftime("%Y/%m/%d %H:%M:%S") }.merge(condition)
      respond json, 401
    end
  end
end
