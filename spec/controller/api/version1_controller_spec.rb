#encoding:utf-8
require "date"
require File.expand_path '../../../spec_helper.rb', __FILE__

describe "API::V1" do
  describe "User" do
    before do
      @user = User.first(email: "admin@intfocus.com")
      @params = @user.to_params.select { |key, vaule| ["email", "password"].include?(key) }
    end

    it "should return user info when login successfully" do
      get "/api/v1/user/login.json", @params
      puts last_response.body

      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body)
      code = json["code"]
      now  = DateTime.parse(json["now"]).strftime("%Y/%m/%d %H:%M:%S")
      expired_at = json["expired_at"]

      expect(code).to eq(200)
      expect(now).to  eq(DateTime.now.strftime("%Y/%m/%d %H:%M:%S"))
      expect(expired_at).to eq((@user.expired_at||DateTime.now).strftime("%Y/%m/%d %H:%M:%S"))
    end

    it "should return user info when validate successfully" do
    end
  end

  describe "Track Email Status" do
    it "should generate a track url when post submit" do
      params = {
      }
      post "/api/v1/track/url.json", params
    end
  end
  describe "Pre Paid Code" do
    before do
      @params = {
        email:    "admin@intfocus.com",
        password: "123456"
      }
    end

    it "should generate pre-paid-code with administrator" do
      pre_paid_type = "month"
      get "/api/v1/%s/pre_paid_code.json" % pre_paid_type, @params

      expect(last_response).to be_ok

      json = JSON.parse(last_response.body)
      pre_paid_code = json["pre_paid_code"] 
      pre_paid_type = json["pre_paid_type"]

      expect(pre_paid_code.size).to eq(32)
      expect(pre_paid_type).to eq("month")
    end
  end
end
