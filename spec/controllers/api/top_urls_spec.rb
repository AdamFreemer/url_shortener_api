require 'rails_helper'

RSpec.describe Api::V1::TopUrlsController, type: :controller do
  describe 'GET #index' do
    let!(:link1) { Link.create(url: 'https://www.apple.com', slug: 'ABC123') }
    let!(:link2) { Link.create(url: 'https://www.google.com', slug: 'ABC124') }
    let!(:link3) { Link.create(url: 'https://www.skidoo.com', slug: 'ABC125') }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all records with no search constraints' do
      get :index
      expect(JSON.parse(response.body).count).to eq(Link.count)
    end
  end
end
