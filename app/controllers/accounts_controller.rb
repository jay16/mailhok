#encoding: utf-8 
class AccountsController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/accounts"
  before do
    authenticate!
  end

  # account
  # page index
  # GET /account
  get "/" do
    @tracks  = current_user.tracks
    @records = current_user.records
    @orders  = current_user.orders

    haml :index, layout: :"../layouts/layout"
  end

  # get /account/edit
  get "/edit" do
  end

  # post /account/update
  post "/update" do
  end
end
