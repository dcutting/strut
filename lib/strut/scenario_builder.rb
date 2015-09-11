module Strut
  class ScenarioBuilder
    def initialize(document_builder, command_factory)
      @document_builder = document_builder
      @command_factory = command_factory
    end

    def extract_scenario_for_interaction(interaction, fixture, node)
      instance = "instance" # TODO
      line = node["line"]
      stages = node["value"]

      append_make_command(line, instance, fixture)
      append_uri_command(line, instance, interaction.uri)
      append_method_command(line, instance, interaction.method)
      append_given_commands(stages, instance)
      append_execute_command(line, instance)
      append_then_commands(stages, instance)
      append_status_command(line, instance, interaction.statusCode)
    end

    def append_make_command(line, instance, class_name)
      metadata = CommandMetadata.new(line)
      make_command = @command_factory.make_make_command(metadata, instance, class_name)
      @document_builder.append_command(make_command)
    end

    def append_uri_command(line, instance, uri)
      if uri
        metadata = CommandMetadata.new(line)
        path_command = make_set_command(line, instance, "uri", uri)
        @document_builder.append_command(path_command)
      end
    end

    def append_method_command(line, instance, method)
      if method
        metadata = CommandMetadata.new(line)
        method_command = make_set_command(line, instance, "method", method)
        @document_builder.append_command(method_command)
      end
    end

    def append_given_commands(stages, instance)
      given_stages = stages_with_names(stages, ["given", "when"])
      parse_stages(given_stages) { |k, v| make_given_command(k, v, instance) }
    end

    def append_execute_command(line, instance)
      metadata = CommandMetadata.new(line)
      execute_command = @command_factory.make_call_command(metadata, instance, "execute")
      @document_builder.append_command(execute_command)
    end

    def append_then_commands(stages, instance)
      then_stages = stages_with_names(stages, ["then"])
      parse_stages(then_stages) { |k, v| make_then_command(k, v, instance) }
    end

    def append_status_command(line, instance, statusCode)
      if statusCode
        metadata = CommandMetadata.new(line, statusCode)
        status_command = @command_factory.make_call_command(metadata, instance, "statusCode")
        @document_builder.append_command(status_command)
      end
    end

    def make_given_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      make_set_command(line, instance, property_name, value)
    end

    def make_set_command(line, instance, name, value)
      metadata = CommandMetadata.new(line)
      @command_factory.make_call_command(metadata, instance, "set_#{name}", value)
    end

    def make_then_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      metadata = CommandMetadata.new(line, value)
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
