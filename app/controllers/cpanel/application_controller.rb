#encoding: utf-8
module Cpanel; end
class Cpanel::ApplicationController < ApplicationController
  before do
    authenticate!
  end
end
