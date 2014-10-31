#encoding: utf-8 
class Account::TracksController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/tracks"

  # list
  # GET /cpanel/tracks
  get "/" do
    @tracks = current_user.tracks.normals

    haml :index, layout: :"../layouts/layout"
  end


  # show 
  # GET /tracks/:id
  get "/:id" do
    @track = current_user.tracks.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end
end
