#encoding: utf-8
module Account; end
class Account::ApplicationController < ApplicationController
  before do
    #print_format_logger(params)
    authenticate!
  end

end
