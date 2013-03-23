require "newrelic-rake/version"
require "newrelic-rake/instrument"

module NewRelic
  module Rake
    class <<self
      def started=(started)
        @started = started
      end

      def started?
        !!@started
      end
    end
  end
end
