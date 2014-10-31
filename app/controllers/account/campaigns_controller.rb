#encoding: utf-8 
class Account::CampaignsController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/campaigns"

  # list
  # GET /cpanel/campaigns
  get "/" do
    @campaigns = current_user.campaigns.normals

    haml :index, layout: :"../layouts/layout"
  end

  # new
  # GET /cpanel/new
  get "/new" do
    @campaign = current_user.campaigns.new

    haml :new, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/campaigns
  post "/" do
    campaign_params = params[:campaign].merge({
      :to   => params[:campaign][:tos],
      :mid  => uuid(params[:campaign][:subject]),
      :type => "web"
    })
    current_user.campaigns.create(campaign_params)
    redirect "/account/campaigns"
  end

  # show 
  # GET /campaigns/:id
  get "/:id" do
    @campaign = current_user.campaigns.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  # edit
  # GET /campaigns/:id/edit
  get "/:id/edit" do
    @campaign = current_user.campaigns.first(id: params[:id])

    haml :edit, layout: :"../layouts/layout"
  end

  # update
  # POST /campaigns/:id
  post "/:id" do
    campaign = current_user.campaigns.first(id: params[:id])
    campaign.update(params[:campaign])

    redirect "/cpanel/campaigns/%d" % campaign.id
  end

  # delete
  # DELETE /cpanel/campaigns/:id
  delete "/:id" do
    campaign = current_user.campaigns.first(id: params[:id])
    campaign.soft_destroy_with_logger
  end
end
