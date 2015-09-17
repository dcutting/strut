require "strut/config"
require "strut/parser"
require "strut/report_builder"
require "strut/report_printer"
require "strut/slim_client"
require "strut/version"

module Strut
  def self.run(args)
    Strut.new.run(args)
  end

  class Strut
    def run(args)
      config_file = args.shift || ".strut.yml"
      config = read_config(config_file)

      yaml = File.read(config.swagger)
      document = Parser.new(config.namespace).parse(yaml)

      responses = get_responses(config, document)
      exit if responses.nil?

      report = ReportBuilder.new.build(responses, document)
      ReportPrinter.new(yaml).print_report(report)
    end

    def read_config(config_file)
      begin
        return Config.new(config_file)
      rescue => e
        puts e
        exit
      end
    end

    def get_responses(config, document)
      pid = config.runner ? spawn(config.runner) : nil
      begin
        client = SlimClient.new(config.host, config.port, config.max_attempts)
        return client.responses_for_commands(document.commands)
      rescue => e
        puts e
      ensure
        Process.kill("KILL", pid) unless pid.nil?
      end
    end
  end
end
