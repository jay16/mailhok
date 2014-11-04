#encoding: utf-8
module Cpanel; end
class Cpanel::ApplicationController < ApplicationController
  before do
    #print_format_logger(params)
    authenticate!
    redirect "/account" if not current_user.admin?
  end
end
