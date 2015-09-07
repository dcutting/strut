module Strut
  class Report
    def initialize
      @messages = {}
    end

    def add_message_for_line(line, type, message = "")
      if @messages[line].nil? or @messages[line].type == :ok
        @messages[line] = ReportMessage.new(type, message)
      end
    end

    def message_for_line(line)
      @messages[line]
    end
  end

  class ReportMessage
    attr_reader :type, :message

    def initialize(type, message)
      @type = type
      @message = message
    end
  end
end
