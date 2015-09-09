require "strut/extensions"
require "strut/document_builder"
require "strut/interaction_factory"
require "strut/slim_command"
require "strut/slim_command_factory"

module Strut
  class Parser
    def initialize
      @command_factory = SlimCommandFactory.new
      @document_builder = DocumentBuilder.new
      @interaction_factory = InteractionFactory.new
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
      wrapped_node = {"value" => node, "line" => 0}
      extract_scenarios_for_node("", wrapped_node, [])
    end

    def extract_scenarios_for_node(node_name, node, path_stack)
      if node_name.start_with?("x-scenario-")
        interaction = @interaction_factory.make_interaction(path_stack)
        extract_scenario_for_interaction(interaction, node_name, node)
      else
        extract_scenarios_for_children(node["value"], path_stack)
      end
    end

    def extract_scenarios_for_children(node, path_stack)
      return unless node.respond_to?(:each_pair)
      node.each_pair do |child_node_name, child_node|
        next_path_stack = path_stack + [child_node_name]
        extract_scenarios_for_node(child_node_name.to_s, child_node, next_path_stack)
      end
    end

    def extract_scenario_for_interaction(interaction, node_name, node)
      fixture = node_name.gsub(/^x-scenario-/, "")
      puts "--- fixture: #{fixture}"
      puts "    interaction: #{interaction}"
      puts "    nodes: #{node}"
      make_commands(interaction, fixture, node)
    end

    def make_commands(interaction, fixture, params)
      instance = "instance" # TODO

      line = params["line"]

      make_command = make_make_command(line, instance, fixture)
      @document_builder.append_command(make_command)

      stages = params["value"]

      given_stages = stages_with_names(stages, ["given", "when"])
      parse_stages(given_stages) { |k, v| make_given_command(k, v, instance) }

      execute_command = make_execute_command(line, instance)
      @document_builder.append_command(execute_command)

      then_stages = stages_with_names(stages, ["then"])
      parse_stages(then_stages) { |k, v| make_then_command(k, v, instance) }

      unless interaction.statusCode.nil?
        status_command = make_status_command(line, instance, interaction.statusCode)
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
