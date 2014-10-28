#encoding: utf-8 
class Cpanel::PackagesController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/packages"
  #set :haml, layout: :"../layouts/layout"


  # list
  # GET /cpanel/packages
  get "/" do
    @packages = Package.normals

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
    package_params = params[:package].merge({ :creator_id => current_user.id })
    Package.create(package_params)

    redirect "/cpanel/packages"
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
    package_params = params[:package].merge({ :editor_id => current_user.id })
    package.update(package_params)

    redirect "/cpanel/packages"#/%d" % package.id
  end

  # update [onsale]
  # POST /cpanel/packages/:id/onsale
  post "/:id/onsale" do
    package = Package.first(id: params[:id])
    package.update(:onsale => params[:onsale])
    redirect "/cpanel/packages"
  end

  # delete
  # DELETE /cpanel/packages/:id
  delete "/:id/:status" do
    package = Package.first(id: params[:id])
    case params[:status] 
    when "soft","hard", "undo"
      package.update(delete_status: params[:status])
    else
      puts "Wrong Params: %s" % params
    end
  end
end
