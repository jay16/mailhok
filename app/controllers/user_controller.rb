#encoding: utf-8 
class UserController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/user"

  # get /user/login
  get "/login" do
    haml :login, layout: :"../layouts/layout"
  end

  # login /user/login
  post "/login" do
    user = User.first(email: params[:user][:email])
    if user and user.password == params[:user][:password]
      response.set_cookie "cookie_user_login_state", {:value=> user.email, :path => "/", :max_age => "2592000"}

      flash[:success] = "登陆成功"
      redirect request.cookies["cookie_before_login_path"] || "/account"
    else
      response.set_cookie "cookie_user_login_state", {:value=> "", :path => "/", :max_age => "2592000"}

      flash[:warning] = "登陆失败"
      redirect "/login"
    end
  end

  # register page
  # get /user/register
  get "/register" do
    haml :register, layout: :"../layouts/layout"
  end

  # register user
  # 1. email format validate in view
  # 2. password & password_confirmation
  # 3. email uniq
  # post /user/register
  post "/register" do
    if params[:user].has_key?("confirm_password")
      params[:user].delete("confirm_password")
    end
    user = User.create(params[:user])

    flash[:success] = "hi %s, 注册成功，请登陆..." % user.email
    redirect "/user/login"
  end

  # logout
  # delete /user/logout
  get "/logout" do
    response.set_cookie "cookie_user_login_state", {:value=> "", :path => "/", :max_age => "2592000"}
    redirect "/"
  end
end
