#encoding: utf-8
module Cpanel; end
class Cpanel::ApplicationController < ApplicationController
  before do
    authenticate!

   # @paths ||= %w[home orders packages records users].map { |i| "/cpanel/%s" % i }.unshift("/cpanel")
   # if @paths.include?(request.path)
   #   @cpanel_header = true
   # end
  end
end
