#encoding: utf-8 
class Cpanel::RecordsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/records"

  # list
  # GET /cpanel/records
  get "/" do
    @records = Record.normals

    haml :index, layout: :"../layouts/layout"
  end

  # show 
  # GET /cpanel/records/:id
  get "/:id" do
    @record = Record.first(:id => params[:id])
  end

  # edit
  # GET /cpanel/records/:id/edit
  get "/:id/edit" do
    @record = Record.first(:id => params[:id])
  end

  # create
  # POST /cpanel/records
  post "/" do
  end

  # delete
  # DELETE /cpanel/records/:id
  delete "/:id" do
  end
end
