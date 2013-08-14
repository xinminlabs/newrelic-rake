require 'new_relic/agent/method_tracer'

DependencyDetection.defer do
  @name = :rake

  depends_on do
    defined?(::Rake) and not ::NewRelic::Control.instance['disable_rake']
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Rake instrumentation'
  end

  executes do
    ::Rake::Task.class_eval do
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      alias_method :origin_execute, :execute
      def execute(args=nil)
        if ignore_metric_reporting?
          origin_execute(args)
        else
          execute_with_newrelic_trace(args)
        end
      end

      # Make sure NewRelic agent flush data to the server according to
      # https://newrelic.com/docs/ruby/monitoring-ruby-background-processes-and-daemons
      # even though Agent configuration is :send_data_on_exit => true
      at_exit { NewRelic::Agent.shutdown }

      def execute_with_newrelic_trace(args)
        unless ::NewRelic::Rake.started?
          ::NewRelic::Agent.manual_start(:dispatcher => :rake)
          ::NewRelic::Rake.started = true
        end
        perform_action_with_newrelic_trace(:name => self.name, :category => "OtherTransaction/Rake") do
          origin_execute(args)
        end
      end

      def ignore_metric_reporting?
        self.name == 'jobs:work'
      end
    end
  end

end
