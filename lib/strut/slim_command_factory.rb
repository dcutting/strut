require "strut/slim_command"

module Strut
  class SlimCommandFactory
    def initialize
      @command_id = 0
    end

    def next_command_id
      @command_id += 1
      @command_id
    end

    def make_import_command(metadata, namespace)
      id = next_command_id
      ImportCommand.new(id, metadata, namespace)
    end

    def make_make_command(metadata, instance, class_name)
      id = next_command_id
      MakeCommand.new(id, metadata, instance, class_name)
    end

    def make_call_command(metadata, instance, property, value = nil)
      id = next_command_id
      CallCommand.new(id, metadata, instance, property, value)
    end
  end
end
