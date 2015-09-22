require "strut/extensions"
require "strut/document_builder"
require "strut/interaction_factory"
require "strut/scenario_builder"
require "strut/slim_command"
require "strut/slim_command_factory"

module Strut
  class Parser
    X_SCENARIO_PREFIX = "x-scenario-"

    def initialize(namespace)
      @namespace = namespace
      @command_factory = SlimCommandFactory.new
      @document_builder = DocumentBuilder.new
      @interaction_factory = InteractionFactory.new
      @scenario_builder = ScenarioBuilder.new(@document_builder, @command_factory)
      @scenario_number = 0
    end

    def parse(yaml)
      parsed_yaml = Psych::parse_yaml(yaml)
      append_import_command
      extract_scenarios(parsed_yaml)
      @document_builder.document
    end

    def append_import_command
      metadata = CommandMetadata.new(1)
      import_command = @command_factory.make_import_command(metadata, @namespace)
      @document_builder.append_command(import_command)
    end

    def extract_scenarios(node)
      wrapped_node = {"value" => node, "line" => 0}
      extract_scenarios_for_node("", wrapped_node, [])
    end

    def extract_scenarios_for_node(node_name, node, path_stack)
      if node_name.start_with?(X_SCENARIO_PREFIX)
        fixture = node_name.gsub(/^#{X_SCENARIO_PREFIX}/, "")
        interaction = @interaction_factory.make_interaction(path_stack)
        @scenario_number = @scenario_builder.extract_scenarios_for_interaction(@scenario_number, interaction, fixture, node)
      else
        extract_scenarios_for_children(@scenario_number, node["value"], path_stack)
      end
    end

    def extract_scenarios_for_children(scenario_number, node, path_stack)
      return unless node.respond_to?(:each_pair)
      node.each_pair do |child_node_name, child_node|
        next_path_stack = path_stack + [child_node_name]
        extract_scenarios_for_node(child_node_name.to_s, child_node, next_path_stack)
      end
    end
  end
end
