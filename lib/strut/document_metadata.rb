module Strut
  class DocumentMetadata
    def initialize
      @command_id = 0
      @commands = []
      @line_metadata = {}
    end

    def set_metadata_for_command_id(command_id, line_metadata)
      @line_metadata[command_id] = line_metadata
    end

    def metadata_for_command_id(command_id)
      @line_metadata[command_id]
    end

    def store_command(line_metadata, slim_command)
      set_metadata_for_command_id(slim_command.@id, line_metadata)
      @commands << slim_command
      @command_id += 1
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
