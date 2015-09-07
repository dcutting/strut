module Strut
  class SlimCommand
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
    def initialize(id, instance, property, value = nil)
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
end
