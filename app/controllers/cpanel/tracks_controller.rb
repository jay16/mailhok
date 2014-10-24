#encoding: utf-8 
class Cpanel::TracksController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/tracks"

  # list
  # GET /cpanel/tracks
  get "/" do
    @tracks = Track.all

    haml :index, layout: :"../layouts/layout"
  end

  # show 
  # GET /cpanel/tracks/:id
  get "/:id" do
    @track = Track.first(:id => params[:id])
  end

  # edit
  # GET /cpanel/tracks/:id/edit
  get "/:id/edit" do
    @track = Track.first(:id => params[:id])
  end

  # create
  # POST /cpanel/tracks
  post "/" do
    subject = params[:subject]
    uid     = params[:uid]
    email   = params[:mid]
    desc    = params[:to]
    _uid = "%s%s%s%s%d%d" % [subject, uid, email, desc, Time.now.to_i, rand()]
    uid = Digest::MD5.hexdigest(_uid)
    @track = Track.create({
      :subject => subject,
      :user_id => uid,
      :email   => email,
      :desc    => desc,
      :uid     => uid,
      :type    => "browser"
    })
  end

  # delete
  # DELETE /cpanel/tracks/:id
  delete "/:id" do
  end

end
