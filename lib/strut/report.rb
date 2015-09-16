module Strut
  ANNOTATION_OK = :ok
  ANNOTATION_FAIL = :fail
  ANNOTATION_EXCEPTION = :exception

  Annotation = Struct.new(:type, :message)

  class Report
    attr_reader :number_scenarios, :number_passed, :number_failed, :number_skipped

    def initialize
      @annotations = {}
      @scenario_results = Hash.new { |h, k| h[k] = [] }
    end

    def add_ok_for_line(scenario_number, line)
      add_annotation_for_line(scenario_number, line, ANNOTATION_OK)
    end

    def add_fail_for_line(scenario_number, line, message)
      add_annotation_for_line(scenario_number, line, ANNOTATION_FAIL, message)
    end

    def add_exception_for_line(scenario_number, line, message)
      add_annotation_for_line(scenario_number, line, ANNOTATION_EXCEPTION, message)
    end

    def add_annotation_for_line(scenario_number, line, type, message = "")
      if @annotations[line].nil? or @annotations[line].type == :ok
        @annotations[line] = Annotation.new(type, message)
      end
      ary = @scenario_results[scenario_number] << type unless scenario_number.nil?
    end

    def annotation_for_line(line)
      @annotations[line]
    end

    def number_scenarios
      @scenario_results.count
    end

    def number_passed
      @scenario_results.select { |k, v| collapse_scenario_annotations(v) == ANNOTATION_OK }.count
    end

    def number_failed
      @scenario_results.select { |k, v| collapse_scenario_annotations(v) == ANNOTATION_FAIL }.count
    end

    def number_skipped
      @scenario_results.select { |k, v| collapse_scenario_annotations(v) == ANNOTATION_EXCEPTION }.count
    end

    def collapse_scenario_annotations(annotations)
      return ANNOTATION_EXCEPTION if annotations.include?(ANNOTATION_EXCEPTION)
      return ANNOTATION_FAIL if annotations.include?(ANNOTATION_FAIL)
      return ANNOTATION_OK
    end
  end
end
