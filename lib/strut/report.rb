require "strut/scenario_result"

module Strut
  class Report
    attr_reader :number_scenarios, :number_passed, :number_failed, :number_skipped, :errors

    def initialize
      @scenario_results = []
      @errors = []
    end

    def add_scenario_result(result)
      @scenario_results << result
    end

    def add_error(error)
      @errors << error
    end

    def annotations_for_line(line)
      all_annotations = @scenario_results.map do |result|
        result.annotations_for_line(line)
      end
      all_annotations.reject { |a| a.empty? }.flatten
    end

    def number_scenarios
      @scenario_results.count
    end

    def number_passed
      number_with_result(SCENARIO_PASS)
    end

    def number_failed
      number_with_result(SCENARIO_FAIL)
    end

    def number_skipped
      number_with_result(SCENARIO_ERROR)
    end

    def number_with_result(result)
      @scenario_results.select { |scenario| scenario.result == result }.count
    end
  end
end
