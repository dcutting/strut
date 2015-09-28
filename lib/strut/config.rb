require "pathname"
require "strut/extensions"

module Strut
  class Config
    attr_reader :swagger, :runner, :host, :port, :max_attempts, :namespace, :output

    def initialize(config_file)
      path = File.dirname(config_file)
      read_and_store(config_file, path)
    end

    def read_and_store(config_file, path)
      yaml = File.read(config_file)
      parsed_yaml = Psych::parse_yaml(yaml)
      store_values(parsed_yaml, path)
    end

    def store_values(yaml, config_path)
      @swagger = swagger_path(yaml, config_path)
      @runner = extract_optional_value(yaml, "runner")
      @host = extract_value(yaml, "host")
      @port = extract_int_value(yaml, "port")
      @max_attempts = extract_int_value(yaml, "max_attempts")
      @namespace = extract_value(yaml, "namespace")
      @output = extract_enum_value(yaml, "output", [:junit, :pretty])
    end

    def swagger_path(yaml, config_path)
      swagger_path = Pathname.new(extract_value(yaml, "swagger"))
      unless swagger_path.absolute?
        swagger_path = Pathname.new(config_path) + swagger_path
      end
      swagger_path.to_s
    end

    def extract_optional_value(yaml, name)
      extract_value(yaml, name, true)
    end

    def extract_value(yaml, name, optional = false)
      value = yaml[name]
      value = value["value"] unless value.nil?
      throw "No '#{name}' specified." if value.nil? and !optional
      value
    end

    def extract_int_value(yaml, name)
      value = extract_value(yaml, name).to_i
      throw "'#{name}' must be a number > 0." unless value > 0
      value
    end

    def extract_enum_value(yaml, name, enums)
      value = extract_value(yaml, name).to_sym
      throw "'#{name}' must be one of #{enums}." unless enums.include?(value)
      value
    end
  end
end
