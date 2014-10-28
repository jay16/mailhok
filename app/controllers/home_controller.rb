﻿#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root page
  get "/" do
    redirect "/account" if current_user

    haml :index, layout: :"../layouts/layout"
  end

  get "/store" do
    @packages = Package.all(:onsale => true)

    haml :store, layout: :"../layouts/layout"
  end

  # redirect to cpanel
  get "/admin" do
    redirect "/account"
  end

  # redirect
  # login
  get "/login" do
    redirect "/user/login"
  end
  # register
  get "/register" do
    redirect "/user/register"
  end

end
