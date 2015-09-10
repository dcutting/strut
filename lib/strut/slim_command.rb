module Strut
  CommandMetadata = Struct.new(:line, :expected_value)

  class SlimCommand
    attr_reader :id
    attr_reader :metadata

    def initialize(id, metadata)
      @id = id
      @metadata = metadata
    end

    def to_a
      [@id, command]
    end
  end

  class ImportCommand < SlimCommand
    def initialize(id, metadata, namespace)
      super(id, metadata)
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
    def initialize(id, metadata, instance, class_name)
      super(id, metadata)
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
    def initialize(id, metadata, instance, property, value)
      super(id, metadata)
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
end
