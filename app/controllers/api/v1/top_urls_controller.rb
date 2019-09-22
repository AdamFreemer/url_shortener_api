module Api::V1
  class TopUrlsController < ApplicationController
    def index
      binding.pry
      # render json: top_100
    end

    private

    def top_100
      # Return top 100 viewed urls
    end
  end
end
