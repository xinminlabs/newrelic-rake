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

      alias_method :origin_invoke_with_call_chain, :invoke_with_call_chain
      def invoke_with_call_chain(task_args, invocation_chain)
        # empty invocation chain invoke first and only once
        if invocation_chain.is_a? Rake::InvocationChain::EmptyInvocationChain
          NewRelic::Agent.manual_start(:dispatcher => :rake)
        end
        origin_invoke_with_call_chain(task_args, invocation_chain)
      end

      alias_method :origin_execute, :execute
      def execute(args=nil)
        perform_action_with_newrelic_trace(:name => self.name, :category => "OtherTransaction/Rake") do
          origin_execute(args)
        end
      end

      # Make sure NewRelic agent flush data to the server according to
      # https://newrelic.com/docs/ruby/monitoring-ruby-background-processes-and-daemons
      # even though Agent configuration is :send_data_on_exit => true
      at_exit { NewRelic::Agent.shutdown }
    end
  end
end
