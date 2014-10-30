#encoding: utf-8 
class Cpanel::UsersController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/users"

  # list
  # GET /cpanel/users
  get "/" do
    @users = User.normals

    haml :index, layout: :"../layouts/layout"
  end

  # show 
  # GET /cpanel/users/:id
  get "/:id" do
    @user = User.first(:id => params[:id])
  end

  # edit
  # GET /cpanel/users/:id/edit
  get "/:id/edit" do
    @user = User.first(:id => params[:id])
  end

  # create
  # POST /cpanel/users
  post "/" do
    @user = User.first(:id => params[:id])
    @user.update_with_logger(params[:user])
  end

  # delete
  # DELETE /cpanel/users/:id
  delete "/:id" do
  end
end

