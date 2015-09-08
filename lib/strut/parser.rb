require "strut/extensions"
require "strut/slim_command"
require "strut/document_metadata"

module Strut
  class Parser
    def initialize
      @document_metadata = DocumentMetadata.new
    end

    def parse(yaml)
      parsed_yaml = parse_yaml(yaml)
      paths = parsed_yaml["paths"]["value"]
      build_commands(paths)
      @document_metadata
    end

    def parse_yaml(yaml)
      handler = LineNumberHandler.new
      parser =  Psych::Parser.new(handler)
      handler.parser = parser
      parser.parse(yaml)
      handler.root.to_ruby.first
    end

    def build_commands(paths)
      add_import_command
      extract_scenarios_for_paths(paths)
    end

    def add_import_command
      line_metadata = LineMetadata.new(0, nil)
      import_command = ImportCommand.new(@document_metadata.@command_id, "specs")
      @document_metadata.store_command(line_metadata, import_command)
    end

    def extract_scenarios_for_paths(paths)
      paths.each do |path, path_value|
        extract_scenarios_for_path(path, path_value)
      end
    end

    def extract_scenarios_for_path(path, path_value)
      path_value["value"].each do |method, method_value|
        extract_scenarios_for_method(path, method, method_value)
      end
    end

    def extract_scenarios_for_method(path, method, method_value)
      if method.start_with?("x-scenario-")
        scenario = method.gsub(/^x-scenario-/, "")
        make_slim_commands(path, nil, nil, scenario, method_value)
      else
        responses = method_value["value"]["responses"]
        responses["value"].each do |response, response_value|
          response_value["value"].each do |key, response_value_value|
            if key.start_with? "x-scenario-"
              scenario = key.gsub(/^x-scenario-/, "")
              make_slim_commands(path, method, response, scenario, response_value_value)
            end
          end
        end
      end
    end

    def make_given_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      line_metadata = make_line_metadata(line)
      slim_command = CallCommand.new(@command_id, instance, "set#{property_name}", value)
      [line_metadata, slim_command]
    end

    def make_line_metadata(line, value = nil)
      LineMetadata.new(line, value)
    end

    def make_then_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      line_metadata = make_line_metadata(line, value)
      slim_command = CallCommand.new(@command_id, instance, property_name)
      [line_metadata, slim_command]
    end

    def stages_with_names(stages, names)
      names.map { |name| stages[name] }.reject { |stage| stage.nil? }.map { |stage| stage["value"] }
    end

    def make_execute_command(line, instance)
      line_metadata = make_line_metadata(line)
      slim_command = CallCommand.new(@command_id, instance, "execute")
      [line_metadata, slim_command]
    end

    def make_status_command(line, instance, status)
      line_metadata = make_line_metadata(line, status)
      slim_command = CallCommand.new(@command_id, instance, "statusCode")
      [line_metadata, slim_command]
    end

    def make_make_command(line, instance, class_name)
      line_metadata = make_line_metadata(line)
      slim_command = MakeCommand.new(@command_id, instance, class_name)
      [line_metadata, slim_command]
    end

    def parse_stages(stages, &block)
      stages.each do |stage|
        stage.each do |k, v|
          (line_metadata, slim_command) = block.call(k, v)
          store_command(line_metadata, slim_command)
        end
      end
    end

    def make_slim_commands(path, method, status, scenario, params)
      instance = "instance_#{@command_id}"

      line = params["line"]

      (line_metadata, make_command) = make_make_command(line, instance, scenario)
      store_command(line_metadata, make_command)

      stages = params["value"]

      given_stages = stages_with_names(stages, ["given", "when"])
      parse_stages(given_stages) { |k, v| make_given_command(k, v, instance) }

      (line_metadata, execute_command) = make_execute_command(line, instance)
      store_command(line_metadata, execute_command)

      then_stages = stages_with_names(stages, ["then"])
      parse_stages(then_stages) { |k, v| make_then_command(k, v, instance) }

      unless status.nil?
        (line_metadata, status_command) = make_status_command(line, instance, status)
        store_command(line_metadata, status_command)
      end
    end
  end
end
