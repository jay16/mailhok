#encoding: utf-8 
class RespondController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/respond"

  # /respond/:mid
  get "/:mid" do
    mid = params[:mid]
    if mid and mid.length == 32
      asset_path = "%s/app/assets/images" % ENV["APP_ROOT_PATH"]
      file_path  = "%s/favicon.ico" % asset_path
      track = Track.first(mid: mid)
      puts track.to_params
      record = Record.create({
        :track_id => track.id,
        :ip      => remote_ip,
        :browser => remote_browser
      })
      #if not record.save
      #  puts "%s" % record.errors.inspect
      #end
      #puts record.to_params
      send_file(file_path,:type => "image/jpeg", :disposition => "inline") 
    end
  end
end
