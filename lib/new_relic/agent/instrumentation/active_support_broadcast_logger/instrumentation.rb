# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.
# frozen_string_literal: true

module NewRelic::Agent::Instrumentation
  module ActiveSupportBroadcastLogger
    def record_one_broadcast_with_new_relic(*args)
      if broadcasts && broadcasts[1..-1]
        broadcasts[1..-1].each { |broadcasted_logger| broadcasted_logger.instance_variable_set(:@skip_instrumenting, true) }
        yield
        broadcasts.each { |broadcasted_logger| broadcasted_logger.instance_variable_set(:@skip_instrumenting, false) }
      else
        NewRelic::Agent.logger.error('Error recording broadcasted logger')
      end
    end
  end
end
