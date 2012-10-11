DependencyDetection.defer do
  @name = :rake

  depends_on do
    defined?(::Rake) and not ::NewRelic::Control.instance['disable_rake']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Rake instrumentation'
  end

  executes do
    ::Rake::Task.class_eval do
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      alias_method :origin_invoke, :invoke
      def invoke(*args)
        NewRelic::Agent.manual_start
        perform_action_with_newrelic_trace(:name => self.name, :category => "OtherTransaction/Rake") do
          origin_invoke(*args)
        end
      ensure
        NewRelic::Agent.shutdown
      end
    end
  end
end

