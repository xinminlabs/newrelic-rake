require 'test/unit'
require 'mocha/setup'
require 'newrelic-rake'

class TestNewRelicRake < Test::Unit::TestCase
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

  def test_ignore_delayed_job
    Rake::Task.define_task('jobs:work')
    Rake::Task['jobs:work'].invoke
    assert !@engine.metrics.include?('OtherTransaction/Rake/Rake::Task/jobs:work'), 'jobs:work task is in metrics'
  end

  def test_metrics
    Rake::Task.define_task('foo')
    Rake::Task['foo'].invoke
    assert @engine.metrics.include?('OtherTransaction/Rake/Rake::Task/foo'), 'rake task is not in metrics'
  end

  def test_dispatcher
    NewRelic::Agent.expects(:manual_start)
    Rake::Task.define_task('bar')
    Rake::Task['bar'].invoke
  end
end
