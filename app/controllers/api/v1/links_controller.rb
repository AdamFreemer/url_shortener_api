module Api::V1
  class LinksController < ApplicationController
    require 'open-uri'
    include Utility
    before_action :new_link, only: [:create]
    before_action :find_link, only: [:show]

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
          json_response({ message: 'This url already exists in the database', status: 409 })
        else
          json_response({ message: 'An unknown error has occurred', status: 404 })
        end
      end
    end

    def show
      if @link
        increment_link_view
        redirect_to(@link.url)
      else
        json_response({ link: 'Invalid url', status: 404 })
      end
    end
  end
end
