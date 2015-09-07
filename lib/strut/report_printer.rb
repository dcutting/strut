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
        report_message = report.message_for_line(index+1)
        line.chomp!
        if report_message.nil?
          print_line(line)
        elsif
          print_message_and_line(report_message, line)
        end
      end
    end

    def print_line(line)
      puts line
    end

    def print_message_and_line(report_message, line)
      case report_message.type
      when :exception
        print yellow { on_black { report_message.message } }, "\n"
        print black { on_yellow { line } }, "\n"
      when :fail
        print red { on_white { report_message.message } }, "\n"
        print white { on_red { line } }, "\n"
      else
        print black { on_green { line } }, "\n"
      end
    end
  end
end
