require "strut/report"

module Strut
  class ReportBuilder
    def build(responses, document)
      report = Report.new

      scenario_results = Hash.new { |h, k| h[k] = ScenarioResult.new }
      responses.each do |response|
        handle_response(response, document, report, scenario_results)
      end

      scenario_results.each_pair do |_, result|
        report.add_scenario_result(result)
      end

      report
    end

    def handle_response(response, document, report, scenario_results)
      command_id, command_result = *response
      if command_id == "error"
        report.add_error(command_result.to_s)
      else
        metadata = document.metadata_for_command_id(command_id)
        if metadata
          process_result(command_result, metadata, report, scenario_results)
        else
          report.add_error("Unexpected response from Slim: #{response.inspect}")
        end
      end
    end

    def process_result(result, metadata, report, scenario_results)
      scenario_result = scenario_results[metadata.scenario_number]
      scenario_result.name = "Scenario #{metadata.scenario_number}, line #{metadata.line}"

      if exception_message = exceptional_result?(result)
        scenario_result.add_exception_for_line(metadata.line, exception_message)
      elsif failed_result?(result, metadata)
        fail_message = "Expected #{metadata.expected_value} but got #{result}"
        scenario_result.add_fail_for_line(metadata.line, fail_message)
      else
        scenario_result.add_ok_for_line(metadata.line)
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
