# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'multiverse_helpers'

class CustomAnalyticsEventsTest < Minitest::Test
  include MultiverseHelpers

  setup_and_teardown_agent

  def test_custom_analytics_events_are_submitted
    t0 = freeze_time
    event_aggregator = NewRelic::Agent.agent.custom_event_aggregator
    event_aggregator.record(:dummy_type, :foo => :bar, :baz => :qux)

    NewRelic::Agent.agent.send(:harvest_and_send_analytic_event_data)

    submissions = $collector.calls_for('analytic_event_data')
    assert_equal(1, submissions.size)

    events = submissions.first.events
    assert_equal(1, events.size)
    expected_event = [{'type' => 'dummy_type', 'timestamp' => t0.to_i}, {'foo' => 'bar', 'baz' => 'qux'}]
    assert_equal(expected_event, events.first)
  end
end
