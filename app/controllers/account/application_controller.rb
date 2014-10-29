#encoding: utf-8
module Account; end
class Account::ApplicationController < ApplicationController
  before do
    authenticate!
  end

end
