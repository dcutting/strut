require "rubygems"
require "term/ansicolor"
include Term::ANSIColor
require "strut/report"

module Strut
  class ReportPrinter
    def initialize(lines)
      @lines = lines
    end

    def print_report(report)
      @lines.each_line.each_with_index do |line, index|
        annotation = report.annotation_for_line(index+1)
        print_line_with_annotation(line.chomp, annotation)
      end
    end

    def print_line_with_annotation(line, annotation)
      if annotation.nil?
        print_unannotated_line(line)
      elsif
        print_annotated_line(annotation, line)
      end
    end

    def print_unannotated_line(line)
      puts line
    end

    def print_annotated_line(annotation, line)
      case annotation.type
      when ANNOTATION_EXCEPTION
        print_exception_line(annotation.message, line)
      when ANNOTATION_FAIL
        print_fail_line(annotation.message, line)
      else
        print_ok_line(line)
      end
    end

    def print_exception_line(message, line)
      print yellow { on_black { message } }, "\n"
      print black { on_yellow { line } }, "\n"
    end

    def print_fail_line(message, line)
      print red { on_white { message } }, "\n"
      print white { on_red { line } }, "\n"
    end

    def print_ok_line(line)
      print black { on_green { line } }, "\n"
    end
  end
end
