#encoding: utf-8 
class Account::RecordsController < Account::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/account/records"

  # list
  # GET /cpanel/records
  get "/" do
    @records = current_user.records.normals

    haml :index, layout: :"../layouts/layout"
  end

  # create
  # POST /cpanel/records
  post "/" do
    record.raise_on_save_failure = false
    record_params = params[:record].merge({
      out_trade_no:  uuid(params.to_s),
      pre_paid_code: Time.now.to_f.to_s
    })
    record = current_user.records.new(record_params)
    if record.save
      status = "/%d" % record.id
      pre_paid_code = "%s%du%do%s" % ["ppc", record.user_id, record.id, sample_3_alpha]
      record.update(:pre_paid_code => pre_paid_code)
      build_relation_with_items(record)
    else
      puts "Failed to save record: %s" % record.errors.inspect
    end

      redirect "/cpanel/records%s" % (status || "")
  end

  # show 
  # GET /records/:id
  get "/:id" do
    @record = current_user.records.first(id: params[:id])

    haml :show, layout: :"../layouts/layout"
  end

  ## edit
  ## GET /records/:id/edit
  #get "/:id/edit" do
  #  @record = current_user.records.first(id: params[:id])

  #  haml :edit, layout: :"../layouts/layout"
  #end

  ## update
  ## POST /records/:id
  #post "/:id" do
  #  record = current_user.records.first(id: params[:id])
  #  record.update(params[:record])

  #  redirect "/cpanel/records/%d" % record.id
  #end

  # delete
  # DELETE /cpanel/records/:id
  delete "/:id" do
    record = current_user.records.first(id: params[:id])
    record.record_items.destroy
    record.destroy
  end

  private
    def build_relation_with_items(record)
      JSON.parse("[%s]" % record.detail).each_with_index do |item, index|
        quantity = item.delete("quantity").to_i
        1.upto(quantity) do |i|
          item.merge!({ pre_paid_code: Time.now.to_f.to_s })
          record_item = record.record_items.new(item)
          if record_item.save
            pre_paid_code = "%s%du%do%di%s" % ["ppc", record.user_id, record.id, record_item.id, sample_3_alpha]
            record_item.update(:pre_paid_code => pre_paid_code)
          else
            puts "Failed to save record_item: %s" % record_item.errors.inspect
          end
        end
      end
    end
end
