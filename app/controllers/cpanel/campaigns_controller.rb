#encoding: utf-8 
class Cpanel::CampaignsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/campaigns"

  # list
  # GET /cpanel/campaigns
  get "/" do
    @campaigns = Campaign.normals

    haml :index, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/campaigns
  post "/" do
    Campaign.raise_on_save_failure = false
    campaign_params = params[:campaign].merge({
      out_trade_no:  uuid(params.to_s),
      pre_paid_code: Time.now.to_f.to_s
    })
    campaign = Campaign.new(campaign_params)
    if campaign.save
      status = "/%d" % campaign.id
      pre_paid_code = "%s%du%do%s" % ["ppc", campaign.user_id, campaign.id, sample_3_alpha]
      campaign.update(:pre_paid_code => pre_paid_code)
      build_relation_with_items(campaign)
    else
      puts "Failed to save campaign: %s" % campaign.errors.inspect
    end

      redirect "/cpanel/campaigns%s" % (status || "")
  end

  # show 
  # GET /campaigns/:id
  get "/:id" do
    @campaign = Campaigns.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  ## edit
  ## GET /campaigns/:id/edit
  #get "/:id/edit" do
  #  @campaign = current_user.campaigns.first(id: params[:id])

  #  haml :edit, layout: :"../layouts/layout"
  #end

  ## update
  ## POST /campaigns/:id
  #post "/:id" do
  #  campaign = current_user.campaigns.first(id: params[:id])
  #  campaign.update(params[:campaign])

  #  redirect "/cpanel/campaigns/%d" % campaign.id
  #end

  # delete
  # DELETE /cpanel/campaigns/:id
  delete "/:id" do
    campaign = Campaigns.first(id: params[:id])
    campaign.soft_destroy_with_logger
  end

  private
    def build_relation_with_items(campaign)
      JSON.parse("[%s]" % campaign.detail).each_with_index do |item, index|
        quantity = item.delete("quantity").to_i
        1.upto(quantity) do |i|
          item.merge!({ pre_paid_code: Time.now.to_f.to_s })
          campaign_item = campaign.campaign_items.new(item)
          if campaign_item.save
            pre_paid_code = "%s%du%do%di%s" % ["ppc", campaign.user_id, campaign.id, campaign_item.id, sample_3_alpha]
            campaign_item.update(:pre_paid_code => pre_paid_code)
          else
            puts "Failed to save campaign_item: %s" % campaign_item.errors.inspect
          end
        end
      end
    end
end
