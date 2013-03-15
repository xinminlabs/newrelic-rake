require 'test/unit'
require 'newrelic-rake/instrument'

class TestNewRelicRedis < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def setup
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats

    @sampler = NewRelic::Agent.instance.transaction_sampler
    @sampler.reset!
    @sampler.start_builder
  end

  def teardown
    @sampler.clear_builder
  end

  def test_metrics
    Rake::Task.define_task('foo')
    Rake::Task['foo'].invoke
    assert @engine.metrics.include?('OtherTransaction/Rake/Rake::Task/foo'), 'rake task is not in metrics'
  end
end
