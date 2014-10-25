#encoding: utf-8 
class Cpanel::PackagesController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/packages"
  #set :haml, layout: :"../layouts/layout"


  # list
  # GET /cpanel/packages
  get "/" do
    @packages = Package.all

    haml :index, layout: :"../layouts/layout"
  end

  # new
  # GET /cpanel/new
  get "/new" do
    @package = Package.new

    haml :new, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/packages
  post "/" do
    package = Package.create(params[:package])

    redirect "/cpanel/packages"#/%d" % package.id
  end

  # show 
  # GET /cpanel/packages/:id
  get "/:id" do
    @package = Package.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  # edit
  # GET /cpanel/packages/:id/edit
  get "/:id/edit" do
    @package = Package.first(id: params[:id])

    haml :edit, layout: :"../layouts/layout"
  end

  # update
  # POST /cpanel/packages/:id
  post "/:id" do
    package = Package.first(id: params[:id])
    package.update(params[:package])

    redirect "/cpanel/packages/%d" % package.id
  end

  # delete
  # DELETE /cpanel/packages/:id
  delete "/:id" do
    package = Package.first(id: params[:id])
    package.destroy
  end
end
