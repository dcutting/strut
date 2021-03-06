require "rubygems"
require "term/ansicolor"
include Term::ANSIColor
require "strut/report"

module Strut
  class ReportPrettyFormatter
    def initialize(lines)
      @lines = lines
    end

    def format(report)
      begin
        out = StringIO.new
        $stdout = out
        print_report_to_stdout(report)
      ensure
        $stdout = STDOUT
      end
      out.string
    end

    def print_report_to_stdout(report)
      @lines.each_line.each_with_index do |line, index|
        annotations = report.annotations_for_line(index+1)
        print_line_with_annotations(line.chomp, annotations)
      end
      puts
      print_errors(report)
      print "#{report.number_scenarios} scenarios ("
      print green { "#{report.number_passed} passed" }, ", "
      print red { "#{report.number_failed} failed" }, ", "
      print yellow { "#{report.number_skipped} skipped" }, ")"
    end

    def print_line_with_annotations(line, annotations)
      if annotations.empty?
        print_unannotated_line(line)
      elsif
        print_annotated_line(annotations, line)
      end
    end

    def print_unannotated_line(line)
      puts line
    end

    def print_annotated_line(annotations, line)
      # TODO: print all annotations, not just the first
      annotation = annotations.first

      case annotation.type
      when ANNOTATION_EXCEPTION
        print_exception_line(line, annotation.message)
      when ANNOTATION_FAIL
        print_fail_line(line, annotation.message)
      else
        print_ok_line(line)
      end
    end

    def print_exception_line(line, message)
      print_error_line(line, :black, :on_yellow, message, :yellow, :on_black)
    end

    def print_fail_line(line, message)
      print_error_line(line, :white, :on_red, message, :red, :on_white)
    end

    def print_ok_line(line)
      print_line(line, :black, :on_green)
    end

    def print_error_line(line, line_fg, line_bg, message, message_fg, message_bg)
      print_line(line, line_fg, line_bg)
      print_line(message, message_fg, message_bg)
    end

    def print_line(line, foreground, background)
      puts line.send(foreground).send(background)
    end

    def print_errors(report)
      return if report.errors.empty?
      report.errors.each do |error|
        print red { error }, "\n"
      end
      puts
    end
  end
end
