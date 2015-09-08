module Strut
  class Document
    attr_reader :commands

    def initialize(commands, line_metadata)
      @commands = commands
      @line_metadata = line_metadata
    end

    def metadata_for_command_id(command_id)
      @line_metadata[command_id]
    end
  end

  class DocumentBuilder
    def initialize
      @commands = []
      @line_metadata = {}
    end

    def append_command(line_metadata, slim_command)
      @line_metadata[slim_command.id] = line_metadata
      @commands << slim_command
    end

    def document
      Document.new(@commands, @line_metadata)
    end
  end

  class LineMetadata
    attr_reader :line, :expected_value

    def initialize(line, expected_value)
      @line = line
      @expected_value = expected_value
    end
  end
end
