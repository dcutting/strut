module Strut
  class ScenarioBuilder
    def initialize(document_builder, command_factory)
      @document_builder = document_builder
      @command_factory = command_factory
    end

    def extract_scenarios_for_interaction(scenario_number, interaction, fixture, node)
      instance = "instance"
      line = node["line"]
      scenario_definitions_for_node(node).each do |scenario_stages|
        make_scenario(scenario_number, line, instance, fixture, interaction, scenario_stages)
        scenario_number += 1
      end
      scenario_number
    end

    def scenario_definitions_for_node(node)
      raw_scenarios = node["value"]
      raw_scenarios = [raw_scenarios] if raw_scenarios.respond_to?(:each_pair)
      raw_scenarios
    end

    def make_scenario(scenario_number, line, instance, fixture, interaction, scenario_stages)
      append_make_command(scenario_number, line, instance, fixture)
      append_uri_command(scenario_number, line, instance, interaction.uri, scenario_stages)
      append_method_command(scenario_number, line, instance, interaction.method)
      append_given_commands(scenario_number, scenario_stages, instance)
      append_execute_command(scenario_number, line, instance)
      append_then_commands(scenario_number, scenario_stages, instance)
      append_status_command(scenario_number, line, instance, interaction.statusCode)
    end

    def append_make_command(scenario_number, line, instance, class_name)
      metadata = CommandMetadata.new(scenario_number, line)
      make_command = @command_factory.make_make_command(metadata, instance, class_name)
      @document_builder.append_command(make_command)
    end

    def append_uri_command(scenario_number, line, instance, uri, scenario_stages)
      if uri
        metadata = CommandMetadata.new(scenario_number, line)
        combined_uri = combine_uri_with_parameters(scenario_stages, uri)
        path_command = make_set_command(scenario_number, line, instance, "uri", combined_uri)
        @document_builder.append_command(path_command)
      end
    end

    def append_method_command(scenario_number, line, instance, method)
      if method
        metadata = CommandMetadata.new(scenario_number, line)
        method_command = make_set_command(scenario_number, line, instance, "method", method)
        @document_builder.append_command(method_command)
      end
    end

    def combine_uri_with_parameters(stages, uri)
      combined_uri = uri.dup
      when_stages = stages_with_names(stages, ["when"])
      when_stages.each do |stage|
        stage.each do |k, v|
          argument = v["value"].to_s
          combined_uri.gsub!(/\{#{k}\}/, argument)
        end
      end
      combined_uri
    end

    def append_given_commands(scenario_number, stages, instance)
      given_stages = stages_with_names(stages, ["given", "when"])
      parse_stages(given_stages) { |k, v| make_given_command(scenario_number, k, v, instance) }
    end

    def append_execute_command(scenario_number, line, instance)
      metadata = CommandMetadata.new(scenario_number, line)
      execute_command = @command_factory.make_call_command(metadata, instance, "execute")
      @document_builder.append_command(execute_command)
    end

    def append_then_commands(scenario_number, stages, instance)
      then_stages = stages_with_names(stages, ["then"])
      parse_stages(then_stages) { |k, v| make_then_command(scenario_number, k, v, instance) }
    end

    def append_status_command(scenario_number, line, instance, statusCode)
      if statusCode
        metadata = CommandMetadata.new(scenario_number, line, statusCode)
        status_command = @command_factory.make_call_command(metadata, instance, "statusCode")
        @document_builder.append_command(status_command)
      end
    end

    def make_given_command(scenario_number, property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      make_set_command(scenario_number, line, instance, property_name, value)
    end

    def make_set_command(scenario_number, line, instance, name, value)
      metadata = CommandMetadata.new(scenario_number, line)
      @command_factory.make_call_command(metadata, instance, "set_#{name}", value)
    end

    def make_then_command(scenario_number, property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      metadata = CommandMetadata.new(scenario_number, line, value)
      @command_factory.make_call_command(metadata, instance, property_name)
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
