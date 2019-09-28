RSpec.describe LinkScraperWorker do
  let!(:link) { Link.create(url: 'https://www.apple.com', slug: 'ABC123') }

  describe 'LinkScraperWorker' do
    it 'cues a new job' do
      expect(LinkScraperWorker.new.perform(link.id)).to be_truthy
    end
  end
end
