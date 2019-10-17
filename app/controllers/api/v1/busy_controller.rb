module Api::V1
    class BusyController < ApplicationController
      include Utility
      require 'sidekiq/api'
      
      def index
        json_response(Sidekiq::Queue.new.size)
      end
    end
  end
  