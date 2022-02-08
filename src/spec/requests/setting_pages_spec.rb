require 'rails_helper'

RSpec.describe "SettingPages", type: :request do
  describe "GET /settings" do
    it "returns http success" do
      get "/setting_pages/settings"
      expect(response).to have_http_status(:success)
    end
  end

end
