require "strut/parser"
require "strut/slim_client"
require "strut/report_builder"
require "strut/report_printer"

module Strut
  def self.run(args)
    swagger_filename = args.shift
    host = args.shift
    port = args.shift.to_i

    yaml = File.read(swagger_filename)
    document = Parser.new.parse(yaml)
    responses = SlimClient.new(host, port).responses_for_commands(document.commands)
    report = ReportBuilder.new.build(responses, document)
    ReportPrinter.new(yaml).print_report(report)
  end
end
