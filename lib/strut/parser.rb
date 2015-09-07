require "strut/extensions"

module Strut
  class Parser

    IMPORT_COMMAND = "import"
    MAKE_COMMAND = "make"
    CALL_COMMAND = "call"

    def initialize
      @id = 0
      @commands = []
      @line_metadata = {}
    end

    def parse(yaml)
      handler = LineNumberHandler.new
      parser =  Psych::Parser.new(handler)
      handler.parser = parser
      parser.parse(yaml)
      parsed_yaml = handler.root.to_ruby.first

      paths = parsed_yaml["paths"]

      (line_metadata, import_command) = make_import_command(0, "specs")
      store_command(line_metadata, import_command)

      extract_scenarios_for_paths(paths["value"])

      [@commands, @line_metadata]
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
      slim_command = make_slim_command(CALL_COMMAND, instance, "set#{property_name}", value)
      [line_metadata, slim_command]
    end

    def make_then_command(property_name, value_container, instance)
      line = value_container["line"]
      value = value_container["value"]
      line_metadata = make_line_metadata(line, value)
      slim_command = make_slim_command(CALL_COMMAND, instance, property_name)
      [line_metadata, slim_command]
    end

    def make_line_metadata(line, value = nil)
      metadata = {:line => line}
      metadata[:value] = value unless value.nil?
      metadata
    end

    def make_slim_command(command, instance, property, value = nil)
      slim_command = [@id, command, instance, property]
      slim_command << value unless value.nil?
      slim_command
    end

    def stages_with_names(stages, names)
      names.map { |name| stages[name] }.reject { |stage| stage.nil? }.map { |stage| stage["value"] }
    end

    def store_command(line_metadata, slim_command)
      @line_metadata[@id] = line_metadata
      @commands << slim_command
      @id += 1
    end

    def make_execute_command(line, instance)
      line_metadata = {:line => line}
      slim_command = [@id, CALL_COMMAND, instance, "execute"]
      [line_metadata, slim_command]
    end

    def make_status_command(line, instance, status)
      line_metadata = {:line => line, :value => status}
      slim_command = [@id, CALL_COMMAND, instance, "statusCode"]
      [line_metadata, slim_command]
    end

    def make_make_command(line, instance, class_name)
      line_metadata = {:line => line}
      slim_command = [@id, MAKE_COMMAND, instance, class_name]
      [line_metadata, slim_command]
    end

    def make_import_command(line, namespace)
      line_metadata = {:line => line}
      slim_command = [@id, IMPORT_COMMAND, namespace]
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
      instance = "instance_#{@id}"

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
