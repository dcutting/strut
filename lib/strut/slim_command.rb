module Strut
  class SlimCommand
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def to_a
      [@id, command]
    end
  end

  class ImportCommand < SlimCommand
    def initialize(id, namespace)
      super(id)
      @namespace = namespace
    end

    def command
      "import"
    end

    def to_a
      super + [@namespace]
    end
  end

  class MakeCommand < SlimCommand
    def initialize(id, instance, class_name)
      super(id)
      @instance = instance
      @class_name = class_name
    end

    def command
      "make"
    end

    def to_a
      super + [@instance, @class_name]
    end
  end

  class CallCommand < SlimCommand
    def initialize(id, instance, property, value)
      super(id)
      @instance = instance
      @property = property
      @value = value
    end

    def command
      "call"
    end

    def to_a
      ary = super + [@instance, @property]
      ary << @value unless @value.nil?
      ary
    end
  end

  class CommandFactory
    def initialize
      @command_id = 0
    end

    def next_command_id
      @command_id += 1
      @command_id
    end

    def make_import_command(namespace)
      id = next_command_id
      ImportCommand.new(id, namespace)
    end

    def make_make_command(instance, class_name)
      id = next_command_id
      MakeCommand.new(id, instance, class_name)
    end

    def make_call_command(instance, property, value = nil)
      id = next_command_id
      CallCommand.new(id, instance, property, value)
    end
  end
end
