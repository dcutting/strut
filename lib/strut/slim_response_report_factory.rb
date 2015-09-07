module Strut
  class SlimResponseReportFactory
    def make_report(responses, line_metadata)
      line_results = {}

      responses.each do |response|
        id, result = *response
        id = id.to_i
        line, expected_value = extract_line_metadata(line_metadata, id)
        if result =~ /^__EXCEPTION__:message:(.+)/
          add_line_result(line_results, line, :exception, $1)
        else
          matched = expected_value.to_s == result.to_s
          if expected_value && !matched
            error_message = "Expected #{expected_value} but got #{result.to_s}"
            add_line_result(line_results, line, :fail, error_message)
          else
            add_line_result(line_results, line, :ok, "")
          end
        end
      end

      line_results
    end

    def extract_line_metadata(line_metadata, id)
      line = line_metadata[id][:line]
      value = line_metadata[id][:value]
      [line, value]
    end

    def add_line_result(line_results, line, type, message)
      if line_results[line].nil? or line_results[line][:type] == :ok
        line_results[line] = {:type => type, :message => message}
      end
    end
  end
end
