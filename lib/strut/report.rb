module Strut
  REPORT_OK = :ok
  REPORT_FAIL = :fail
  REPORT_EXCEPTION = :exception

  ReportMessage = Struct.new(:type, :message)

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
end
