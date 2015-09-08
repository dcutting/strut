module Strut
  class Document
    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

    def metadata_for_command_id(id)
      command = @commands.find { |c| c.id == id }
      command.metadata
    end
  end

  class DocumentBuilder
    def initialize
      @commands = []
    end

    def append_command(command)
      @commands << command
    end

    def document
      Document.new(@commands)
    end
  end
end
