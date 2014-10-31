#encoding: utf-8 
class TrackController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/track"

  # /track/:mid
  get "/:mid" do
    mid = params[:mid]
    if mid and mid.length == 32
      asset_path = "%s/app/assets/images" % ENV["APP_ROOT_PATH"]
      file_path  = "%s/favicon.ico" % asset_path
      campaign = Campaign.first(mid: mid)
      record = campaign.tracks.new({
        :ip      => remote_ip,
        :browser => remote_browser
      })
      if not record.save
        puts "%s" % record.errors.inspect
      end
      send_file(file_path,:type => "image/jpeg", :disposition => "inline") 
    end
  end
end
