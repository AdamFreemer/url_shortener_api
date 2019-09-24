module Api::V1
  class LinksController < ApplicationController
    before_action :new_link, only: [:create]
    before_action :find_link, only: [:show]

    def create
      # Instead of find_or_create_by, which is prone to race conditions,
      # I decided use a take on the new Rails 6 create_or_find_by which leverages
      # table indexes to eliminate the race condition and minimize db hits.
      # There are negatives as well, but can discuss in review.
      begin
        @link.assign_attributes(url: params[:url], slug: Link.generate_slug)
        json_response(@link) if @link.save
      rescue ActiveRecord::RecordNotUnique => e
        if e.message.include? index_slug
          retry
        elsif e.message.include? index_url
          json_response({ message: "This url already exists in the database.", status: 404 })
        else
          json_response({ message: "An unknown error has occurred.", status: 404 })
        end
      end
    end

    def show
      if @link
        json_response(@link)
      else
        json_response({ link: "Invalid url", status: 404 })
      end
    end

    private

    def index_slug
      Link.index_slug
    end

    def index_url
      Link.index_url
    end

    def new_link
      @link = Link.new
    end

    def find_link
      @link = Link.find_by(slug: params[:id])
    end

    def json_response(object, status = 200)
      render json: object, status: status
    end
  end
end
