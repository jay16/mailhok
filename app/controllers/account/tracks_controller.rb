#encoding: utf-8 
class Account::TracksController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/tracks"

  # list
  # GET /cpanel/tracks
  get "/" do
    @tracks = current_user.tracks

    haml :index, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/tracks
  post "/" do
    track.raise_on_save_failure = false
    track_params = params[:track].merge({
      out_trade_no:  uuid(params.to_s),
      pre_paid_code: Time.now.to_f.to_s
    })
    track = current_user.tracks.new(track_params)
    if track.save
      status = "/%d" % track.id
      pre_paid_code = "%s%du%do%s" % ["ppc", track.user_id, track.id, sample_3_alpha]
      track.update(:pre_paid_code => pre_paid_code)
      build_relation_with_items(track)
    else
      puts "Failed to save track: %s" % track.errors.inspect
    end

      redirect "/cpanel/tracks%s" % (status || "")
  end

  # show 
  # GET /tracks/:id
  get "/:id" do
    @track = current_user.tracks.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  ## edit
  ## GET /tracks/:id/edit
  #get "/:id/edit" do
  #  @track = current_user.tracks.first(id: params[:id])

  #  haml :edit, layout: :"../layouts/layout"
  #end

  ## update
  ## POST /tracks/:id
  #post "/:id" do
  #  track = current_user.tracks.first(id: params[:id])
  #  track.update(params[:track])

  #  redirect "/cpanel/tracks/%d" % track.id
  #end

  # delete
  # DELETE /cpanel/tracks/:id
  delete "/:id" do
    track = current_user.tracks.first(id: params[:id])
    track.track_items.destroy
    track.destroy
  end

  private
    def build_relation_with_items(track)
      JSON.parse("[%s]" % track.detail).each_with_index do |item, index|
        quantity = item.delete("quantity").to_i
        1.upto(quantity) do |i|
          item.merge!({ pre_paid_code: Time.now.to_f.to_s })
          track_item = track.track_items.new(item)
          if track_item.save
            pre_paid_code = "%s%du%do%di%s" % ["ppc", track.user_id, track.id, track_item.id, sample_3_alpha]
            track_item.update(:pre_paid_code => pre_paid_code)
          else
            puts "Failed to save track_item: %s" % track_item.errors.inspect
          end
        end
      end
    end
end
