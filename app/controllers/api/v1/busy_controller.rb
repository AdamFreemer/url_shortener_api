module Api::V1
    class BusyController < ApplicationController
      include Utility
      require 'sidekiq/api'

      def index
        stats = Sidekiq::Stats.new
        json_response(stats.enqueued)
      end
    end
  end
  