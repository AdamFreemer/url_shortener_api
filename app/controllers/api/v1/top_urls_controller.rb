module Api::V1
  class TopUrlsController < ApplicationController
    include Utility
    
    def index
      json_response(top_100)
    end
  end
end
