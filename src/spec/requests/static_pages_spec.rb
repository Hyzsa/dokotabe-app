require "rails_helper"

RSpec.describe "Static Pages", type: :request do
  describe "GET /" do
    example "ホーム画面の表示に成功すること" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    example "お問い合わせ画面の表示に成功すること" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end
end
