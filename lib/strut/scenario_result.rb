module Strut
  SCENARIO_RESULT_PASS = "pass"

  ANNOTATION_OK = :ok
  ANNOTATION_FAIL = :fail
  ANNOTATION_EXCEPTION = :exception

  Annotation = Struct.new(:type, :message)

  class ScenarioResult
    attr_accessor :name, :time, :result

    def initialize
      @annotations = {}
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
      if @annotations[line].nil? or @annotations[line].type == :ok
        @annotations[line] = Annotation.new(type, message)
      end
    end

    def annotation_for_line(line)
      @annotations[line]
    end
  end
end
