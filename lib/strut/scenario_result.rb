require "strut/annotation"

module Strut
  SCENARIO_PASS = "pass"
  SCENARIO_FAIL = "fail"
  SCENARIO_ERROR = "error"

  class ScenarioResult
    attr_accessor :name, :time, :result

    def initialize
      @annotations = Hash.new { |h, k| h[k] = [] }
    end

    def add_ok_for_line(line)
      add_annotation_for_line(line, ANNOTATION_OK)
    end

    def add_fail_for_line(line, message)
      add_annotation_for_line(line, ANNOTATION_FAIL, message)
    end

    def add_exception_for_line(line, message)
      add_annotation_for_line(line, ANNOTATION_EXCEPTION, message)
    end

    def add_annotation_for_line(line, type, message = "")
      @annotations[line] << Annotation.new(type, message)
    end

    def annotations_for_line(line)
      @annotations[line]
    end

    def result
      return SCENARIO_ERROR if @annotations.include?(ANNOTATION_EXCEPTION)
      return SCENARIO_FAIL if @annotations.include?(ANNOTATION_FAIL)
      return SCENARIO_PASS
    end
  end
end
