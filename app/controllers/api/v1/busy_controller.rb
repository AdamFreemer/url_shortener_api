module Api::V1
    class BusyController < ApplicationController
      include Utility
      require 'sidekiq/api'
      stats = Sidekiq::Stats.new

      def index
        stats = Sidekiq::Stats.new
        json_response(stats.processed)
      end
    end
  end
  