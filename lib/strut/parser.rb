require "strut/extensions"
require "strut/slim_command"
require "strut/slim_command_factory"
require "strut/document_builder"

module Strut
  Interaction = Struct.new(:uri, :method, :statusCode)

  class Parser
    def initialize
      @command_factory = SlimCommandFactory.new
      @document_builder = DocumentBuilder.new
    end

    def parse(yaml)
      parsed_yaml = parse_yaml(yaml)
      append_import_command
      extract_scenarios(parsed_yaml)
      @document_builder.document
    end

    def parse_yaml(yaml)
      handler = LineNumberHandler.new
      parser =  Psych::Parser.new(handler)
      handler.parser = parser
      parser.parse(yaml)
      handler.root.to_ruby.first
    end

    def append_import_command
      metadata = CommandMetadata.new(0)
      import_command = @command_factory.make_import_command(metadata, "specs")
      @document_builder.append_command(import_command)
    end

    def extract_scenarios(node)
      paths_key = "paths"
      extract_scenarios_for_node(paths_key, node[paths_key]["value"], Interaction.new)
    end

    def extract_scenarios_for_node(node_name, node, interaction)
      node.each do |child_node_name, child_node|
        puts ">>> #{child_node_name}"
        if child_node_name.start_with?("x-scenario-")
          extract_scenario_for_interaction(interaction, child_node_name, child_node["value"])
        else
          case node_name
          when "paths"
            interaction.uri = node_name
          when http_method?(node_name)
            interaction.method = node_name
          when "responses"
            interaction.statusCode = node_name
          end
          extract_scenarios_for_node(child_node_name, child_node["value"], interaction)
        end
      end
    end

    def http_method?(name)
      ["get", "post", "put", "delete", "head", "options"].include?(name)
    end

    def extract_scenario_for_interaction(interaction, node_name, node)
      fixture = node_name.gsub(/^x-scenario-/, "")
      puts ">>> fixture: #{fixture}"
      # make_commands(path, nil, nil, scenario, method_value)
    end

    def extract_scenarios_for_path(path_uri, path_children)
      path_children["value"].each do |method_name, method_children|
        if method_name.start_with?("x-scenario-")
        else
          extract_scenarios_for_method(path_uri, method_name, method_children)
        end
      end
    end

    def extract_scenarios_for_method(path_uri, method_name, method_children)
      if method_name.start_with?("x-scenario-")
        scenario = method.gsub(/^x-scenario-/, "")
        make_commands(path, nil, nil, scenario, method_value)
      else
        responses = method_value["value"]["responses"]
        responses["value"].each do |response, response_value|
          response_value["value"].each do |key, response_value_value|
            if key.start_with? "x-scenario-"
              scenario = key.gsub(/^x-scenario-/, "")
              make_commands(path, method, response, scenario, response_value_value)
            end
          end
        end
      end
    end

    def make_commands(path, method, status, scenario, params)
      instance = "instance_#{@command_id}" # TODO

      line = params["line"]

      make_command = make_make_command(line, instance, scenario)
      @document_builder.append_command(make_command)

      stages = params["value"]

      given_stages = stages_with_names(stages, ["given", "when"])
      parse_stages(given_stages) { |k, v| make_given_command(k, v, instance) }

      execute_command = make_execute_command(line, instance)
      @document_builder.append_command(execute_command)

      then_stages = stages_with_names(stages, ["then"])
      parse_stages(then_stages) { |k, v| make_then_command(k, v, instance) }

      unless status.nil?
        status_command = make_status_command(line, instance, status)
        @document_builder.append_command(status_command)
      end
    end

    def make_given_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      metadata = CommandMetadata.new(line)
      @command_factory.make_call_command(metadata, instance, "set#{property_name}", value)
    end

    def make_then_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      metadata = CommandMetadata.new(line, value)
      @command_factory.make_call_command(metadata, instance, property_name)
    end

    def make_execute_command(line, instance)
      metadata = CommandMetadata.new(line)
      @command_factory.make_call_command(metadata, instance, "execute")
    end

    def make_status_command(line, instance, status)
      metadata = CommandMetadata.new(line, status)
      @command_factory.make_call_command(metadata, instance, "statusCode")
    end

    def make_make_command(line, instance, class_name)
      metadata = CommandMetadata.new(line)
      @command_factory.make_make_command(metadata, instance, class_name)
    end

    def stages_with_names(stages, names)
      names.map { |name| stages[name] }.reject { |stage| stage.nil? }.map { |stage| stage["value"] }
    end

    def parse_stages(stages, &block)
      stages.each do |stage|
        stage.each do |k, v|
          command = block.call(k, v)
          @document_builder.append_command(command)
        end
      end
    end
  end
end
