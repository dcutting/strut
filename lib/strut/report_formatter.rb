require "rubygems"
require "term/ansicolor"
include Term::ANSIColor

module Strut
  class ReportFormatter
    def initialize(lines)
      @lines = lines
    end

    def format_report(report)
      @lines.each_line.each_with_index do |line, index|
        line_result = report[index+1]
        line.chomp!
        if line_result.nil?
          puts line
        elsif
          type = line_result[:type]
          case type
          when :exception
            print yellow { on_black { line_result[:message] } }, "\n"
            print black { on_yellow { line } }, "\n"
          when :fail
            print red { on_black { line_result[:message] } }, "\n"
            print white { on_red { line } }, "\n"
          else
            print black { on_green { line } }, "\n"
          end
        end
      end
    end
  end
end
