require "strut/document"

module Strut
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
