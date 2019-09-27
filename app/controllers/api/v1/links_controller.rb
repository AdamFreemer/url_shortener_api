module Api::V1
  class LinksController < ApplicationController
    require 'open-uri'
    include Utility
    before_action :new_link, only: [:create]
    before_action :find_link, only: [:show]

    # Instead of find_or_create_by, which is prone to race conditions,
    # I decided use a take on the new Rails 6 create_or_find_by which leverages
    # table indexes to eliminate the race condition and minimize db hits.
    # There are negatives as well, but can discuss in review.
    def create
      begin
        @link.assign_attributes(url: params[:url], slug: Link.generate_slug)
        if @link.save
          link_title_scraper(@link)
          create_json_response(@link) 
        end
      rescue ActiveRecord::RecordNotUnique => e
        if e.message.include? link_index_slug
          retry
        elsif e.message.include? link_index_url
          json_response({ message: "This url already exists in the database", status: 404 })
        else
          json_response({ message: "An unknown error has occurred", status: 404 })
        end
      end
    end

    def show
      if @link
        increment_link_view
        json_response(@link)
      else
        json_response({ link: "Invalid url", status: 404 })
      end
    end
  end
end
