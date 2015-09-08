require "strut/report"

module Strut
  class ReportBuilder
    def build(responses, document)
      report = Report.new

      responses.each do |response|
        command_id, result = *response
        command_id = command_id.to_i
        metadata = document.metadata_for_command_id(command_id)
        if result =~ /^__EXCEPTION__:message:(.+)/
          report.add_exception_for_line(metadata.line, $1)
        else
          matched = metadata.expected_value.to_s == result.to_s
          if metadata.expected_value && !matched
            error_message = "Expected #{metadata.expected_value} but got #{result.to_s}"
            report.add_fail_for_line(metadata.line, error_message)
          else
            report.add_ok_for_line(metadata.line)
          end
        end
      end

      report
    end
  end
end
