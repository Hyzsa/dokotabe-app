require "rails_helper"

RSpec.describe "devise", type: :request do
  describe "GET /users/sign_in" do
    example "ログインページのHTTPリクエストが成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/sign_up" do
    example "新規登録ページのHTTPリクエストが成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
