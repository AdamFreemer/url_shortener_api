class LinkScraperWorker
  require 'open-uri'
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(link_id)
    link = Link.find(link_id)
    begin
      url = Nokogiri::HTML(open(link.url))
      url_title = url.at_css('title').text
    rescue OpenURI::HTTPError => e
      link.update(title: "== url title was unavailable ==")
    else
      link.update(title: url_title)
    end
  end
end
