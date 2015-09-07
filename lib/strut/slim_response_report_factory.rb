require "strut/report"

module Strut
  class SlimResponseReportFactory
    def make_report(responses, line_metadata)
      report = Report.new

      responses.each do |response|
        id, result = *response
        id = id.to_i
        line, expected_value = extract_line_metadata(line_metadata, id)
        if result =~ /^__EXCEPTION__:message:(.+)/
          report.add_message_for_line(line, :exception, $1)
        else
          matched = expected_value.to_s == result.to_s
          if expected_value && !matched
            error_message = "Expected #{expected_value} but got #{result.to_s}"
            report.add_message_for_line(line, :fail, error_message)
          else
            report.add_message_for_line(line, :ok)
          end
        end
      end

      report
    end

    def extract_line_metadata(line_metadata, id)
      line = line_metadata[id][:line]
      value = line_metadata[id][:value]
      [line, value]
    end
  end
end
