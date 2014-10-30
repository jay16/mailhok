#encoding: utf-8 
class Account::TracksController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/tracks"

  # list
  # GET /cpanel/tracks
  get "/" do
    @tracks = current_user.tracks.normals

    haml :index, layout: :"../layouts/layout"
  end

  # new
  # GET /cpanel/new
  get "/new" do
    @track = current_user.tracks.new

    haml :new, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/tracks
  post "/" do
    track_params = params[:track].merge({
      :to   => params[:track][:tos],
      :mid  => uuid(params[:track][:subject]),
      :type => "web"
    })
    current_user.tracks.create(track_params)
    redirect "/account/tracks"
  end

  # show 
  # GET /tracks/:id
  get "/:id" do
    @track = current_user.tracks.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  # edit
  # GET /tracks/:id/edit
  get "/:id/edit" do
    @track = current_user.tracks.first(id: params[:id])

    haml :edit, layout: :"../layouts/layout"
  end

  # update
  # POST /tracks/:id
  post "/:id" do
    track = current_user.tracks.first(id: params[:id])
    track.update(params[:track])

    redirect "/cpanel/tracks/%d" % track.id
  end

  # delete
  # DELETE /cpanel/tracks/:id
  delete "/:id" do
    track = current_user.tracks.first(id: params[:id])
    track.track_items.destroy
    track.destroy
  end
end
