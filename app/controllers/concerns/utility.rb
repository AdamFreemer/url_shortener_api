module Utility
  extend ActiveSupport::Concern

  def json_response(object, status = 200)
    render json: object, status: status
  end

  def create_json_response(object)
    render json: object, status: 200, serializer: CreateLinkSerializer
  end

  def new_link
    @link = Link.new
  end

  def find_link
    @link = Link.find_by(slug: params[:id])
  end

  def link_index_slug
    Link.index_slug
  end

  def link_index_url
    Link.index_url
  end

  def top_100
    Link.all
  end

  def increment_link_view
    @link.increment(:views, 1)
    @link.save
  end

  def link_title_scraper(link)
    LinkScraperWorker.perform_async(link.id)
  end

  def url_formatter(raw_url)
    sanitized_url = raw_url.gsub(/\s+/, "").downcase
    final_url =
      if sanitized_url =~ /http[s]?:\/\// 
        sanitized_url
      else
        "http://#{sanitized_url}"
      end
    raw_url.include?('https') ? final_url.gsub(/http?:\/\// , 'https') : final_url
  end
end
