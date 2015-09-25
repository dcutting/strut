require "strut/scenario_result"

module Strut
  class Report
    attr_reader :number_scenarios, :number_passed, :number_failed, :number_skipped

    def initialize
      @scenario_results = []
      @errors = []
    end

    def add_error(error)
      @errors << error
    end

    def add_scenario_result(result)
      @scenario_results << result
    end

    def annotation_for_line(line)
      @scenario_results.each do |result|
        annotation = result.annotation_for_line(line)
        return annotation unless annotation.nil?
      end
      nil
    end

    def number_scenarios
      0
    end

    def number_passed
      0
    end

    def number_failed
      0
    end

    def number_skipped
      0
    end
  end
end
