require "strut/report"

module Strut
  class ReportBuilder
    def build(responses, document)
      report = Report.new
      responses.each do |response|
        handle_response(response, document, report)
      end
      report
    end

    def handle_response(response, document, report)
      command_id, result = *response
      if command_id == "error"
        report.add_fail_for_line(1, result.to_s)
      else
        metadata = document.metadata_for_command_id(command_id)
        if metadata
          process_result(result, metadata, report)
        else
          report.add_fail_for_line(1, "unexpected response from Slim: #{response.inspect}")
        end
      end
    end

    def process_result(result, metadata, report)
      if exception_message = exceptional_result?(result)
        report.add_exception_for_line(metadata.line, exception_message)
      elsif failed_result?(result, metadata)
        fail_message = "Expected #{metadata.expected_value} but got #{result}"
        report.add_fail_for_line(metadata.line, fail_message)
      else
        report.add_ok_for_line(metadata.line)
      end
    end

    def exceptional_result?(result)
      result =~ /^__EXCEPTION__:message:(.+)/ ? $1 : nil
    end

    def failed_result?(result, metadata)
      metadata.expected_value && metadata.expected_value.to_s != result.to_s
    end
  end
end
