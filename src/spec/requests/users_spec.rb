require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    it 'リクエストが成功すること' do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
