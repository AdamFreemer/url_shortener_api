require 'rails_helper'

RSpec.describe Link, type: :model do
  describe '.generate_slug' do
    it 'should return a slug with the appropriate length' do
      expect(Link.generate_slug.length).to be(1)
    end
  end

  describe 'index name class methods confirming table indexes' do
    it 'returns index_links_on_slug for .index_links_on_slug' do
     expect(Link.index_slug).to eq('index_links_on_slug')
    end

    it 'returns index_links_on_url for .index_links_on_slug' do
      expect(Link.index_url).to eq('index_links_on_url')
     end
  end
end
