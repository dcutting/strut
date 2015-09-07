require "strut/swagger_parser"
require "strut/slim_client"
require "strut/slim_response_report_factory"
require "strut/report_formatter"

module Strut
  def self.run(args)

    swagger_filename = args.shift
    host = args.shift
    port = args.shift.to_i

    yaml = File.read(swagger_filename)

    parser = SwaggerParser.new
    commands, line_metadata = parser.parse_yaml(yaml)

    responses = SlimClient.new(host, port).responses_for_commands(commands)
    report = SlimResponseReportFactory.new.make_report(responses, line_metadata)
    ReportFormatter.new(yaml).format_report(report)
  end
end
