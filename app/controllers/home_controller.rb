#encoding: utf-8 
class HomeController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/home"

  # root page
  get "/" do
    if current_user
      redirect "/account"
    end
    haml :index
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
