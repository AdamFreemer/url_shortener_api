require 'rails_helper'

RSpec.describe Api::V1::LinksController, type: :controller do
  describe 'GET #show' do
    let(:link) { Link.create(url: 'https://www.apple.com', slug: 'ABC123') }

    it 'redirects to the correct url' do
      get :show, params: { id: link.slug }
      expect(link).to redirect_to(link.url)
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

    let(:params2) do 
      { 'url': 'Atari.com' }
    end

    it 'returns a sanatized link with the proper prefix' do
      post :create, params: params2
      expect(Link.first.url).to eq('http://atari.com')
    end 
  end
end
