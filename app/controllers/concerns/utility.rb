module Utility
  extend ActiveSupport::Concern

  def json_response(object, status = 200)
    render json: object, status: status
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
end