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

      def execute_with_newrelic_trace(args)
        unless ::NewRelic::Rake.started?
          ::NewRelic::Agent.manual_start
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
