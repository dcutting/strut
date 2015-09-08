require "strut/report"

module Strut
  class ReportBuilder
    def build(responses, document_metadata)
      report = Report.new

      responses.each do |response|
        command_id, result = *response
        command_id = command_id.to_i
        metadata = document_metadata.metadata_for_command_id(command_id)
        if result =~ /^__EXCEPTION__:message:(.+)/
          report.add_message_for_line(metadata.line, :exception, $1)
        else
          matched = metadata.expected_value.to_s == result.to_s
          if metadata.expected_value && !matched
            error_message = "Expected #{metadata.expected_value} but got #{result.to_s}"
            report.add_message_for_line(metadata.line, :fail, error_message)
          else
            report.add_message_for_line(metadata.line, :ok)
          end
        end
      end

      report
    end
  end
end
