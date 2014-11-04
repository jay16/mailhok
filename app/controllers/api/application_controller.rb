#encoding: utf-8
module API; end
class API::ApplicationController < ApplicationController
  before do
    #print_format_logger(params)
  end
  def respond_with_json _body
    raise "code is necessary!" unless _body.has_key?(:code)
    content_type "application/json"
    body   _body.to_json
    status _body[:code]
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
      respond json
    end
  end
end
