#encoding: utf-8 
class Cpanel::TracksController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/tracks"

  # list
  # GET /cpanel/tracks
  get "/" do
    @tracks = Track.normals

    haml :index, layout: :"../layouts/layout"
  end

  # show 
  # GET /cpanel/tracks/:id
  get "/:id" do
    @track = Track.first(:id => params[:id])
  end
end
