require 'rails_helper'

RSpec.describe Api::V1::LinksController, type: :controller do
  describe 'GET #show' do
    let(:link) { Link.create(url: 'https://www.apple.com', slug: 'ABC123') }

    it 'returns the expected record' do
      get :show, params: { id: link.slug }
      
      expect(JSON.parse(response.body)['url']).to eq(Link.first.url)
    end
  end

  describe 'POST #create' do
    let(:params) do 
      { 'url': 'https://www.atari.com' }
    end

    it 'creates a new link and confirms attributes match posted data' do
      post :create, params: params

      expect(Link.first.url).to eq('https://www.atari.com')
    end    

    it 'responds appropriately with duplicate link data submission' do
      post :create, params: params
      post :create, params: params

      expect(JSON.parse(response.body)['message']).to eq('This url already exists in the database')
    end
  end
end
