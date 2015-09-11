module Strut
  class Document
    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

    def metadata_for_command_id(id)
      command = @commands.find { |c| c.id == id }
      command ? command.metadata : nil
    end
  end
end
